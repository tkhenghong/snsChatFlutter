import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/state/bloc/unreadMessage/bloc.dart';

class UnreadMessageBloc extends Bloc<UnreadMessageEvent, UnreadMessageState> {
  UnreadMessageBloc(): super(UnreadMessageLoading());

  UnreadMessageAPIService unreadMessageAPIService = Get.find();
  UnreadMessageDBService unreadMessageDBService = Get.find();

  @override
  Stream<UnreadMessageState> mapEventToState(UnreadMessageEvent event) async* {
    if (event is InitializeUnreadMessagesEvent) {
      yield* _initializeUnreadMessagesToState(event);
    } else if (event is EditUnreadMessageEvent) {
      yield* _editUnreadMessage(event);
    } else if (event is DeleteUnreadMessageEvent) {
      yield* _deleteUnreadMessage(event);
    } else if (event is GetUserPreviousUnreadMessagesEvent) {
      yield* _getPreviousUnreadMessages(event);
    }
  }

  Stream<UnreadMessageState> _initializeUnreadMessagesToState(InitializeUnreadMessagesEvent event) async* {
    if (state is UnreadMessageLoading || state is UnreadMessagesNotLoaded) {
      try {
        List<UnreadMessage> unreadMessageListFromDB = await unreadMessageDBService.getAllUnreadMessage();

        if (isObjectEmpty(unreadMessageListFromDB)) {
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

  Stream<UnreadMessageState> _editUnreadMessage(EditUnreadMessageEvent event) async* {
    bool updatedInREST = false;
    bool unreadMessageSaved = false;

    if (state is UnreadMessagesLoaded) {
      updatedInREST = await unreadMessageAPIService.editUnreadMessage(event.unreadMessage);

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

  Stream<UnreadMessageState> _getPreviousUnreadMessages(GetUserPreviousUnreadMessagesEvent event) async* {
    List<UnreadMessage> unreadMessageListFromServer = await unreadMessageAPIService.getUnreadMessagesOfAUser();
    if (state is UnreadMessagesLoaded) {
      List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

      if (unreadMessageListFromServer != null && unreadMessageListFromServer.length > 0) {
        // Update the current info of the unreadMessage to latest information

        for (UnreadMessage unreadMessageFromServer in unreadMessageListFromServer) {
          // Unable to use contains() method here. Will cause concurrent modification during iteration problem.
          // Link: https://stackoverflow.com/questions/22409666/exception-concurrent-modification-during-iteration-instancelength17-of-gr
          bool unreadMessageExist = false;

          for (UnreadMessage existingUnreadMessage in existingUnreadMessageList) {
            if (existingUnreadMessage.id == unreadMessageFromServer.id) {
              unreadMessageExist = true;
            }
          }

          if (unreadMessageExist) {
            unreadMessageDBService.editUnreadMessage(unreadMessageFromServer);

            existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == unreadMessageFromServer.id);
          } else {
            unreadMessageDBService.addUnreadMessage(unreadMessageFromServer);
          }

          existingUnreadMessageList.add(unreadMessageFromServer);
        }
      }
      yield UnreadMessagesLoaded(existingUnreadMessageList);
      functionCallback(event, true);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
