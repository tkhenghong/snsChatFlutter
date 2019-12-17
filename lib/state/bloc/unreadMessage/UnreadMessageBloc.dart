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
    } else if (event is GetUserPreviousUnreadMessagesEvent) {
      yield* _getPreviousUnreadMessages(event);
    }
  }

  Stream<UnreadMessageState> _initializeUnreadMessagesToState(InitializeUnreadMessagesEvent event) async* {
    try {
      List<UnreadMessage> unreadMessageListFromDB = await unreadMessageDBService.getAllUnreadMessage();

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

          yield UnreadMessagesLoaded(existingUnreadMessageList);
          functionCallback(event, event.unreadMessage);
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

          yield UnreadMessagesLoaded(existingUnreadMessageList);
          functionCallback(event, event.unreadMessage);
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

          yield UnreadMessagesLoaded(existingUnreadMessageList);
          functionCallback(event, true);
        }
      }
    }

    if (!deletedInREST || !unreadMessageDeleted) {
      functionCallback(event, false);
    }
  }

  Stream<UnreadMessageState> _getPreviousUnreadMessages(GetUserPreviousUnreadMessagesEvent event) async* {
    List<UnreadMessage> unreadMessageListFromServer = await unreadMessageAPIService.getUnreadMessagesOfAUser(event.user.id);
    print('UnreadMessageBloc.dart unreadMessageListFromServer: ' + unreadMessageListFromServer.toString());
    print('UnreadMessageBloc.dart unreadMessageListFromServer.length: ' + unreadMessageListFromServer.length.toString());
    if (state is UnreadMessagesLoaded) {
      List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

      if (unreadMessageListFromServer != null && unreadMessageListFromServer.length > 0) {
        // Update the current info of the unreadMessage to latest information

        for (UnreadMessage unreadMessageFromServer in unreadMessageListFromServer) {
          bool unreadMessageExist = existingUnreadMessageList
              .contains((UnreadMessage unreadMessageFromDB) => unreadMessageFromDB.id == unreadMessageFromServer.id);

          if (unreadMessageExist) {
            unreadMessageDBService.editUnreadMessage(unreadMessageFromServer);

            existingUnreadMessageList
                .removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == unreadMessageFromServer.id);
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
