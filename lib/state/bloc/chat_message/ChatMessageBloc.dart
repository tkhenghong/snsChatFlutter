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
    if (event is LoadConversationGroupChatMessagesEvent) {
      yield* _loadConversationGroupChatMessages(event);
    } else if (event is AddChatMessageEvent) {
      yield* _addChatMessage(event);
    } else if (event is DeleteChatMessageEvent) {
      yield* _deleteChatMessage(event);
    } else if (event is RemoveAllChatMessagesEvent) {
      yield* _removeAllChatMessagesEvent(event);
    }
  }

  Stream<ChatMessageState> _loadConversationGroupChatMessages(LoadConversationGroupChatMessagesEvent event) async* {
    Pageable pageable = event.pageable;
    try {
      PageInfo chatMessagePageableResponse = await chatMessageAPIService.getChatMessagesOfAConversation(event.conversationGroupId, pageable);
      List<ChatMessage> chatMessageListFromServer = chatMessagePageableResponse.content.map((chatMessageRaw) => ChatMessage.fromJson(chatMessageRaw)).toList();

      chatMessageDBService.addChatMessages(chatMessageListFromServer);

      yield* updateChatMessageLoadedState(updatedChatMessageList: chatMessageListFromServer);
      functionCallback(event, chatMessagePageableResponse);
    } catch (e) {
      List<ChatMessage> messageListFromDB = await chatMessageDBService.getAllChatMessagesWithPagination(event.conversationGroupId, pageable.page, pageable.size);
      yield* updateChatMessageLoadedState(updatedChatMessageList: messageListFromDB);
      functionCallback(event, null);
    }
  }

  Stream<ChatMessageState> _addChatMessage(AddChatMessageEvent event) async* {
    ChatMessage chatMessageFromServer;
    bool savedIntoDB = false;
    if (state is ChatMessagesLoaded) {
      chatMessageFromServer = await chatMessageAPIService.addChatMessage(event.createChatMessageRequest);

      if (!chatMessageFromServer.isNull) {
        savedIntoDB = await chatMessageDBService.addChatMessage(chatMessageFromServer);

        if (savedIntoDB) {
          List<ChatMessage> existingMessageList = (state as ChatMessagesLoaded).chatMessageList;

          existingMessageList.add(chatMessageFromServer);

          // Very funny. But must change to another state first and switch it back immediately to trigger changes.
          yield ChatMessageLoading();
          yield ChatMessagesLoaded(existingMessageList);
          functionCallback(event, chatMessageFromServer);
        }
      }
      if (chatMessageFromServer.isNull || !savedIntoDB) {
        functionCallback(event, null);
      }
    }
  }

  Stream<ChatMessageState> _deleteChatMessage(DeleteChatMessageEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;
    if (state is ChatMessagesLoaded) {
      deletedInREST = await chatMessageAPIService.deleteChatMessage(event.chatMessageId);
      if (deletedInREST) {
        deleted = await chatMessageDBService.deleteChatMessage(event.chatMessageId);
        if (deleted) {
          List<ChatMessage> existingMessageList = (state as ChatMessagesLoaded).chatMessageList;

          existingMessageList.removeWhere((ChatMessage existingMessage) => existingMessage.id == event.chatMessageId);

          yield ChatMessageLoading();
          yield ChatMessagesLoaded(existingMessageList);
          functionCallback(event, true);
        }
      }
    }

    if (!deletedInREST || !deleted) {
      functionCallback(event, false);
    }
  }

  Stream<ChatMessageState> updateChatMessageLoadedState({List<ChatMessage> updatedChatMessageList, ChatMessage updateChatMessage}) async* {
    if (state is ChatMessagesLoaded) {
      List<ChatMessage> existingChatMessageList = (state as ChatMessagesLoaded).chatMessageList;

      if (!isObjectEmpty(updatedChatMessageList)) {
        updatedChatMessageList.forEach((updatedChatMessage) {
          existingChatMessageList.removeWhere((existingChatMessage) => existingChatMessage.id == updatedChatMessage.id);
        });

        existingChatMessageList.addAll(updatedChatMessageList);
      }

      if (isObjectEmpty(updateChatMessage)) {
        existingChatMessageList.removeWhere((existingChatMessage) => existingChatMessage.id == updateChatMessage.id);
        existingChatMessageList.add(updateChatMessage);
      }

      yield ChatMessageLoading();
      yield ChatMessagesLoaded(existingChatMessageList);
    } else {
      yield ChatMessagesLoaded(updatedChatMessageList);
    }
  }

  Stream<ChatMessageState> _removeAllChatMessagesEvent(RemoveAllChatMessagesEvent event) async* {
    chatMessageDBService.deleteAllChatMessages();
    yield ChatMessagesNotLoaded();
    functionCallback(event, true);
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
