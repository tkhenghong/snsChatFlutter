import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';

import 'bloc.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  ChatMessageBloc() : super(ChatMessageLoading());

  ChatMessageAPIService chatMessageAPIService = Get.find();
  ChatMessageDBService chatMessageDBService = Get.find();

  @override
  Stream<ChatMessageState> mapEventToState(ChatMessageEvent event) async* {
    if (event is InitializeChatMessagesEvent) {
      yield* _initializeChatMessagesToState(event);
    } else if (event is AddChatMessageEvent) {
      yield* _addChatMessage(event);
    } else if (event is EditChatMessageEvent) {
      yield* _editChatMessage(event);
    } else if (event is DeleteChatMessageEvent) {
      yield* _deleteChatMessage(event);
    }
  }

  Stream<ChatMessageState> _initializeChatMessagesToState(InitializeChatMessagesEvent event) async* {
    if (state is ChatMessageLoading || state is ChatMessagesNotLoaded) {
      try {
        List<ChatMessage> messageListFromDB = await chatMessageDBService.getAllChatMessages();

        if (isObjectEmpty(messageListFromDB)) {
          functionCallback(event, false);
          yield ChatMessagesNotLoaded();
        } else {
          yield ChatMessagesLoaded(messageListFromDB);
          functionCallback(event, true);
        }
      } catch (e) {
        functionCallback(event, false);
        yield ChatMessagesNotLoaded();
      }
    }
  }

  Stream<ChatMessageState> _addChatMessage(AddChatMessageEvent event) async* {
    ChatMessage messageFromServer;
    bool savedIntoDB = false;
    if (state is ChatMessagesLoaded) {
      // Avoid reading existing message
      if (isStringEmpty(event.message.id)) {
        messageFromServer = await chatMessageAPIService.addChatMessage(event.message);
      } else {
        messageFromServer = event.message;
      }

      if (!isObjectEmpty(messageFromServer)) {
        savedIntoDB = await chatMessageDBService.addChatMessage(messageFromServer);

        if (savedIntoDB) {
          List<ChatMessage> existingMessageList = (state as ChatMessagesLoaded).chatMessageList;

          existingMessageList.removeWhere((ChatMessage existingMessage) => existingMessage.id == event.message.id);
          existingMessageList.add(messageFromServer);

          // Very funny. But must change to another state first and switch it back immediately to trigger changes.
          yield ChatMessageLoading();
          yield ChatMessagesLoaded(existingMessageList);
          functionCallback(event, messageFromServer);
        }
      }
      if (isObjectEmpty(messageFromServer) || !savedIntoDB) {
        functionCallback(event, null);
      }
    }
  }

  Stream<ChatMessageState> _editChatMessage(EditChatMessageEvent event) async* {
    bool updatedInREST = false;
    bool updated = false;
    if (state is ChatMessagesLoaded) {
      updatedInREST = await chatMessageAPIService.editChatMessage(event.message);
      if (updatedInREST) {
        updated = await chatMessageDBService.editChatMessage(event.message);
        if (updated) {
          List<ChatMessage> existingMessageList = (state as ChatMessagesLoaded).chatMessageList;

          existingMessageList.removeWhere((ChatMessage existingMessage) => existingMessage.id == event.message.id);

          existingMessageList.add(event.message);

          yield ChatMessagesLoaded(existingMessageList);
          functionCallback(event, event.message);
        }
      }
    }

    if (!updatedInREST || !updated) {
      functionCallback(event, null);
    }
  }

  Stream<ChatMessageState> _deleteChatMessage(DeleteChatMessageEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;
    if (state is ChatMessagesLoaded) {
      deletedInREST = await chatMessageAPIService.deleteChatMessage(event.message.id);
      if (deletedInREST) {
        deleted = await chatMessageDBService.deleteChatMessage(event.message.id);
        if (deleted) {
          List<ChatMessage> existingMessageList = (state as ChatMessagesLoaded).chatMessageList;

          existingMessageList.removeWhere((ChatMessage existingMessage) => existingMessage.id == event.message.id);

          yield ChatMessagesLoaded(existingMessageList);
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
