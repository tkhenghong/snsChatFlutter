import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/message/bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageAPIService messageAPIService = MessageAPIService();
  MessageDBService messageDBService = MessageDBService();

  @override
  MessageState get initialState => MessageLoading();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is InitializeMessagesEvent) {
      yield* _initializeMessagesToState(event);
    } else if (event is AddMessageEvent) {
      yield* _addMessage(event);
    } else if (event is EditMessageEvent) {
      yield* _editMessage(event);
    } else if (event is DeleteMessageEvent) {
      yield* _deleteMessage(event);
    }
  }

  Stream<MessageState> _initializeMessagesToState(InitializeMessagesEvent event) async* {
    try {
      List<Message> messageListFromDB = await messageDBService.getAllMessages();

      print("messageListFromDB.length: " + messageListFromDB.length.toString());

      functionCallback(event, true);
      yield MessagesLoaded(messageListFromDB);
    } catch (e) {
      functionCallback(event, false);
      yield MessagesNotLoaded();
    }
  }

  Stream<MessageState> _addMessage(AddMessageEvent event) async* {
    Message messageFromServer;
    bool savedIntoDB = false;
    if (state is MessagesLoaded) {
      messageFromServer = await messageAPIService.addMessage(event.message);

      if (!isObjectEmpty(messageFromServer)) {
        savedIntoDB = await messageDBService.addMessage(messageFromServer);

        if (savedIntoDB) {
          List<Message> existingMessageList = (state as MessagesLoaded).messageList;

          existingMessageList.add(messageFromServer);

          functionCallback(event, messageFromServer);
          yield MessagesLoaded(existingMessageList);
        }
      }
      if (isObjectEmpty(messageFromServer) || !savedIntoDB) {
        functionCallback(event, null);
      }
    }
  }

  Stream<MessageState> _editMessage(EditMessageEvent event) async* {
    bool updatedInREST = false;
    bool updated = false;
    if (state is MessagesLoaded) {
      updatedInREST = await messageAPIService.editMessage(event.message);
      if (updatedInREST) {
        updated = await messageDBService.editMessage(event.message);
        if (updated) {
          List<Message> existingMessageList = (state as MessagesLoaded).messageList;

          existingMessageList.removeWhere((Message existingMessage) => existingMessage.id == event.message.id);

          existingMessageList.add(event.message);

          functionCallback(event, event.message);
          yield MessagesLoaded(existingMessageList);
        }
      }
    }

    if (!updatedInREST || !updated) {
      functionCallback(event, null);
    }
  }

  Stream<MessageState> _deleteMessage(DeleteMessageEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;
    if (state is MessagesLoaded) {
      deletedInREST = await messageAPIService.deleteMessage(event.message.id);
      if (deletedInREST) {
        deleted = await messageDBService.deleteMessage(event.message.id);
        if (deleted) {
          List<Message> existingMessageList = (state as MessagesLoaded).messageList;

          existingMessageList.removeWhere((Message existingMessage) => existingMessage.id == event.message.id);

          functionCallback(event, true);
          yield MessagesLoaded(existingMessageList);
        }
      }
    }

    if (!deletedInREST || !deleted) {
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
