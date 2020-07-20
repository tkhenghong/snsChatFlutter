import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';

import 'bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageLoading());

  MessageAPIService messageAPIService = MessageAPIService();
  ChatMessageDBService messageDBService = ChatMessageDBService();

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
    if (state is MessageLoading || state is MessagesNotLoaded) {
      try {
        List<ChatMessage> messageListFromDB = await messageDBService.getAllChatMessages();

        if (isObjectEmpty(messageListFromDB)) {
          functionCallback(event, false);
          yield MessagesNotLoaded();
        } else {
          print('messageListFromDB: ' + messageListFromDB.length.toString());
          yield MessagesLoaded(messageListFromDB);
          functionCallback(event, true);
        }
      } catch (e) {
        functionCallback(event, false);
        yield MessagesNotLoaded();
      }
    }
  }

  Stream<MessageState> _addMessage(AddMessageEvent event) async* {
    ChatMessage messageFromServer;
    bool savedIntoDB = false;
    if (state is MessagesLoaded) {
      // Avoid readding existing message
      if (isStringEmpty(event.message.id)) {
        messageFromServer = await messageAPIService.addMessage(event.message);
      } else {
        messageFromServer = event.message;
      }

      if (!isObjectEmpty(messageFromServer)) {
        savedIntoDB = await messageDBService.addChatMessage(messageFromServer);

        if (savedIntoDB) {
          List<ChatMessage> existingMessageList = (state as MessagesLoaded).messageList;

          existingMessageList.removeWhere((ChatMessage existingMessage) => existingMessage.id == event.message.id);
          existingMessageList.add(messageFromServer);

          // Very funny. But must change to another state first and switch it back immediately to trigger changes.
          yield MessageLoading();
          yield MessagesLoaded(existingMessageList);
          functionCallback(event, messageFromServer);
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
        updated = await messageDBService.editChatMessage(event.message);
        if (updated) {
          List<ChatMessage> existingMessageList = (state as MessagesLoaded).messageList;

          existingMessageList.removeWhere((ChatMessage existingMessage) => existingMessage.id == event.message.id);

          existingMessageList.add(event.message);

          yield MessagesLoaded(existingMessageList);
          functionCallback(event, event.message);
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
        deleted = await messageDBService.deleteChatMessage(event.message.id);
        if (deleted) {
          List<ChatMessage> existingMessageList = (state as MessagesLoaded).messageList;

          existingMessageList.removeWhere((ChatMessage existingMessage) => existingMessage.id == event.message.id);

          yield MessagesLoaded(existingMessageList);
          functionCallback(event, true);
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
