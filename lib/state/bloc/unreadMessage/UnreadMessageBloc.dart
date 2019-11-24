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
    } else if (event is AddUnreadMessageToStateEvent) {
      yield* _addUnreadMessageToState(event);
    } else if (event is EditUnreadMessageToStateEvent) {
      yield* _editUnreadMessageToState(event);
    } else if (event is DeleteUnreadMessageToStateEvent) {
      yield* _deleteUnreadMessageToState(event);
    } else if (event is ChangeUnreadMessageEvent) {
      yield* _changeUnreadMessage(event);
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

  Stream<UnreadMessageState> _addUnreadMessageToState(AddUnreadMessageToStateEvent event) async* {
    if (state is UnreadMessagesLoaded) {
      List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

      existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

      existingUnreadMessageList.add(event.unreadMessage);

      functionCallback(event, event.unreadMessage);
      yield UnreadMessagesLoaded(existingUnreadMessageList);
    }
  }

  Stream<UnreadMessageState> _editUnreadMessageToState(EditUnreadMessageToStateEvent event) async* {
    if (state is UnreadMessagesLoaded) {
      List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

      existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

      existingUnreadMessageList.add(event.unreadMessage);

      functionCallback(event, event.unreadMessage);
      yield UnreadMessagesLoaded(existingUnreadMessageList);
    }
  }

  Stream<UnreadMessageState> _deleteUnreadMessageToState(DeleteUnreadMessageToStateEvent event) async* {
    if (state is UnreadMessagesLoaded) {
      List<UnreadMessage> existingUnreadMessageList = (state as UnreadMessagesLoaded).unreadMessageList;

      existingUnreadMessageList.removeWhere((UnreadMessage existingUnreadMessage) => existingUnreadMessage.id == event.unreadMessage.id);

      functionCallback(event, true);
      yield UnreadMessagesLoaded(existingUnreadMessageList);
    }
  }

  Stream<UnreadMessageState> _changeUnreadMessage(ChangeUnreadMessageEvent event) async* {

    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(event.unreadMessage);

    if (isObjectEmpty(newUnreadMessage)) {
      functionCallback(event, false);
    }

    bool unreadMessageSaved = await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

    if (!unreadMessageSaved) {
      functionCallback(event, false);
    }

    add(AddUnreadMessageToStateEvent(unreadMessage: newUnreadMessage, callback: (UnreadMessage unreadMessage) {}));
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
