import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/state/bloc/unreadMessage/bloc.dart';

class UnreadMessageBloc extends Bloc<UnreadMessageEvent, UnreadMessageState> {
  UnreadMessageBloc() : super(UnreadMessageLoading());

  UnreadMessageAPIService unreadMessageAPIService = Get.find();
  UnreadMessageDBService unreadMessageDBService = Get.find();

  @override
  Stream<UnreadMessageState> mapEventToState(UnreadMessageEvent event) async* {
    if (event is InitializeUnreadMessagesEvent) {
      yield* _initializeUnreadMessagesToState(event);
    } else if (event is UpdateUnreadMessageEvent) {
      yield* _updateUnreadMessageEvent(event);
    } else if (event is DeleteUnreadMessageEvent) {
      yield* _deleteUnreadMessage(event);
    } else if (event is GetUnreadMessageByConversationGroupIdEvent) {
      yield* _geUnreadMessageByConversationGroupId(event);
    } else if (event is UpdateUnreadMessagesEvent) {
      yield* _getPreviousUnreadMessages(event);
    } else if (event is RemoveAllUnreadMessagesEvent) {
      yield* _removeAllUnreadMessagesEvent(event);
    }
  }

  Stream<UnreadMessageState> _initializeUnreadMessagesToState(InitializeUnreadMessagesEvent event) async* {
    if (state is UnreadMessageLoading || state is UnreadMessagesNotLoaded) {
      try {
        List<UnreadMessage> unreadMessageListFromDB = await unreadMessageDBService.getAllUnreadMessage();

        if (unreadMessageListFromDB.isEmpty) {
          yield UnreadMessagesNotLoaded();
          functionCallback(event, false);
        } else {
          yield UnreadMessagesLoaded(unreadMessageListFromDB);
          functionCallback(event, true);
        }
      } catch (e) {
        yield UnreadMessagesNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  // Only updates localDB and State
  Stream<UnreadMessageState> _updateUnreadMessageEvent(UpdateUnreadMessageEvent event) async* {
    bool updatedInREST = false;
    bool unreadMessageSaved = false;

    if (state is UnreadMessagesLoaded) {
      if (updatedInREST) {
        unreadMessageSaved = await unreadMessageDBService.editUnreadMessage(event.unreadMessage);

        if (unreadMessageSaved) {
          List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

          existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

          existingUnreadMessageList.add(event.unreadMessage);

          yield UnreadMessagesLoaded(existingUnreadMessageList);
          functionCallback(event, event.unreadMessage);
        }
      }
    }
    if (!updatedInREST || !unreadMessageSaved) {
      functionCallback(event, false);
    }
  }

  // Delete Local DB UnreadMessage only**
  Stream<UnreadMessageState> _deleteUnreadMessage(DeleteUnreadMessageEvent event) async* {
    bool deletedInREST = false;
    bool unreadMessageDeleted = false;

    if (state is UnreadMessagesLoaded) {
      unreadMessageDeleted = await unreadMessageDBService.deleteUnreadMessage(event.unreadMessage.id);

      if (unreadMessageDeleted) {
        List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;
        existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

        yield UnreadMessagesLoaded(existingUnreadMessageList);
        functionCallback(event, true);
      }
    }

    if (!deletedInREST || !unreadMessageDeleted) {
      functionCallback(event, false);
    }
  }

  Stream<UnreadMessageState> _geUnreadMessageByConversationGroupId(GetUnreadMessageByConversationGroupIdEvent event) async* {
    UnreadMessage unreadMessage = await unreadMessageAPIService.geUnreadMessageByConversationGroupId(event.conversationGroupId);
    addUnreadMessageIntoDB(unreadMessage);
    List<UnreadMessage> updatedUnreadMessageList = addUnreadMessageIntoState(unreadMessage);

    yield* yieldUnreadMessageState(updatedUnreadMessageList: updatedUnreadMessageList);
  }

  Stream<UnreadMessageState> _getPreviousUnreadMessages(UpdateUnreadMessagesEvent event) async* {
    if (state is UnreadMessagesLoaded) {
      List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

      if (!event.unreadMessages.isNullOrBlank && event.unreadMessages.isNotEmpty) {
        // Update the current info of the unreadMessage to latest information.
        event.unreadMessages.forEach((unreadMessage) {
          unreadMessageDBService.addUnreadMessage(unreadMessage);
          existingUnreadMessageList.add(unreadMessage);
        });
      }
      yield UnreadMessagesLoaded(existingUnreadMessageList);
      functionCallback(event, true);
    }
  }

  Stream<UnreadMessageState> _removeAllUnreadMessagesEvent(RemoveAllUnreadMessagesEvent event) async* {
    unreadMessageDBService.deleteAllUnreadMessage();
    yield UnreadMessagesNotLoaded();
    functionCallback(event, true);
  }

  Future<bool> addUnreadMessageIntoDB(UnreadMessage unreadMessage) async {
    return await unreadMessageDBService.addUnreadMessage(unreadMessage);
  }

  List<UnreadMessage> addUnreadMessageIntoState(UnreadMessage unreadMessage) {
    List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

    existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == unreadMessage.id);

    existingUnreadMessageList.add(unreadMessage);

    return existingUnreadMessageList;
  }

  Stream<UnreadMessageState> yieldUnreadMessageState({List<UnreadMessage> updatedUnreadMessageList}) async* {
    List<UnreadMessage> existingUnreadMessageList;

    if (state is UnreadMessagesLoaded) {
      existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

      if (updatedUnreadMessageList.isNotEmpty) {
        existingUnreadMessageList = updatedUnreadMessageList;
      }
    }

    yield UnreadMessageLoading();

    if (existingUnreadMessageList.isEmpty) {
      yield UnreadMessagesNotLoaded();
    } else {
      yield UnreadMessagesLoaded(existingUnreadMessageList);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
