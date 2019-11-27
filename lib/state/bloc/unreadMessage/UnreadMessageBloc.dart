import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/unreadMessage/bloc.dart';

class UnreadMessageBloc extends Bloc<UnreadMessageEvent, UnreadMessageState> {
  UnreadMessageAPIService unreadMessageAPIService = UnreadMessageAPIService();
  UnreadMessageDBService unreadMessageDBService = UnreadMessageDBService();

  @override
  UnreadMessageState get initialState => UnreadMessageLoading();

  @override
  Stream<UnreadMessageState> mapEventToState(UnreadMessageEvent event) async* {
    if (event is InitializeUnreadMessagesEvent) {
      yield* _initializeUnreadMessagesToState(event);
    } else if (event is AddUnreadMessageEvent) {
      yield* _addUnreadMessage(event);
    } else if (event is EditUnreadMessageEvent) {
      yield* _editUnreadMessage(event);
    } else if (event is DeleteUnreadMessageEvent) {
      yield* _deleteUnreadMessage(event);
    }
  }

  Stream<UnreadMessageState> _initializeUnreadMessagesToState(InitializeUnreadMessagesEvent event) async* {
    try {
      List<UnreadMessage> unreadMessageListFromDB = await unreadMessageDBService.getAllUnreadMessage();

      print("unreadMessageListFromDB.length: " + unreadMessageListFromDB.length.toString());

      yield UnreadMessagesLoaded(unreadMessageListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<UnreadMessageState> _addUnreadMessage(AddUnreadMessageEvent event) async* {
    UnreadMessage newUnreadMessage;
    bool unreadMessageSaved = false;

    if (state is UnreadMessagesLoaded) {
      newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(event.unreadMessage);

      if (!isObjectEmpty(newUnreadMessage)) {
        unreadMessageSaved = await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

        if (unreadMessageSaved) {
          List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

          existingUnreadMessageList
              .removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

          existingUnreadMessageList.add(event.unreadMessage);

          functionCallback(event, event.unreadMessage);
          yield UnreadMessagesLoaded(existingUnreadMessageList);
        }
      }
    }

    if (isObjectEmpty(newUnreadMessage) || !unreadMessageSaved) {
      functionCallback(event, null);
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

          existingUnreadMessageList
              .removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

          existingUnreadMessageList.add(event.unreadMessage);

          functionCallback(event, event.unreadMessage);
          yield UnreadMessagesLoaded(existingUnreadMessageList);
        }
      }
    }
    if (!updatedInREST || !unreadMessageSaved) {
      functionCallback(event, false);
    }
  }

  Stream<UnreadMessageState> _deleteUnreadMessage(DeleteUnreadMessageEvent event) async* {
    bool deletedInREST = false;
    bool unreadMessageDeleted = false;

    if (state is UnreadMessagesLoaded) {
      deletedInREST = await unreadMessageAPIService.deleteUnreadMessage(event.unreadMessage.id);

      if (deletedInREST) {
        unreadMessageDeleted = await unreadMessageDBService.deleteUnreadMessage(event.unreadMessage.id);

        if (unreadMessageDeleted) {
          List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;
          existingUnreadMessageList
              .removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

          functionCallback(event, true);
          yield UnreadMessagesLoaded(existingUnreadMessageList);
        }
      }
    }

    if (!deletedInREST || !unreadMessageDeleted) {
      functionCallback(event, false);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
