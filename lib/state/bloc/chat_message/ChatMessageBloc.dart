import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/index.dart';
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
    } else if (event is UpdateChatMessageEvent) {
      yield* _updateChatMessage(event);
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
    try {
      chatMessageFromServer = await chatMessageAPIService.addChatMessage(event.createChatMessageRequest);

      if (!isObjectEmpty(chatMessageFromServer)) {
        savedIntoDB = await chatMessageDBService.addChatMessage(chatMessageFromServer);

        if (savedIntoDB) {
          yield* updateChatMessageLoadedState(updateChatMessage: chatMessageFromServer);
          functionCallback(event, chatMessageFromServer);
        } else {
          showToast('Unable to save message into database. Please try again later.', Toast.LENGTH_SHORT);
          functionCallback(event, null);
        }
      } else {
        showToast('Unable to send message. Please try again later.', Toast.LENGTH_SHORT);
        functionCallback(event, null);
      }
      if (isObjectEmpty(chatMessageFromServer) || !savedIntoDB) {
        functionCallback(event, null);
      }
    } catch (e) {
      showToast('Failed to send a message. Please try again later.', Toast.LENGTH_LONG, toastGravity: ToastGravity.CENTER);
      functionCallback(event, null);
    }
  }

  /// Update ChatMessage object into DB and state.
  Stream<ChatMessageState> _updateChatMessage(UpdateChatMessageEvent event) async* {
    try {
      print('ChatMessageBloc.dart UpdateChatMessageEvent IN STATE');
      await chatMessageDBService.addChatMessage(event.chatMessage);
      print('ChatMessageBloc.dart CHECKPOINT 9');
      yield* updateChatMessageLoadedState(updateChatMessage: event.chatMessage);
      print('ChatMessageBloc.dart CHECKPOINT 10');
      functionCallback(event, true);
    } catch (e) {
      showToast('Unable to add chat message into the database. Please try again.', Toast.LENGTH_SHORT, toastGravity: ToastGravity.CENTER);
      functionCallback(event, false);
    }
  }

  Stream<ChatMessageState> _deleteChatMessage(DeleteChatMessageEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;
    if (state is ChatMessagesLoaded) {
      deletedInREST = await chatMessageAPIService.deleteChatMessage(event.chatMessage.id);
      if (deletedInREST) {
        deleted = await chatMessageDBService.deleteChatMessage(event.chatMessage.id);
        if (deleted) {
          yield* updateChatMessageLoadedState(deletingChatMessage: event.chatMessage);
          functionCallback(event, true);
        }
      }
    }

    if (!deletedInREST || !deleted) {
      functionCallback(event, false);
    }
  }

  Stream<ChatMessageState> updateChatMessageLoadedState({List<ChatMessage> updatedChatMessageList, ChatMessage updateChatMessage, ChatMessage deletingChatMessage}) async* {
    if (state is ChatMessagesLoaded) {
      List<ChatMessage> existingChatMessageList = (state as ChatMessagesLoaded).chatMessageList;

      if (!isObjectEmpty(updatedChatMessageList)) {
        updatedChatMessageList.forEach((updatedChatMessage) {
          existingChatMessageList.removeWhere((existingChatMessage) => existingChatMessage.id == updatedChatMessage.id);
        });

        existingChatMessageList.addAll(updatedChatMessageList);
      }

      if (!isObjectEmpty(updateChatMessage)) {
        existingChatMessageList.removeWhere((existingChatMessage) => existingChatMessage.id == updateChatMessage.id);
        existingChatMessageList.add(updateChatMessage);
      }

      if (!isObjectEmpty(deletingChatMessage)) {
        existingChatMessageList.removeWhere((existingChatMessage) => existingChatMessage.id == deletingChatMessage.id);
      }

      yield ChatMessageLoading();
      yield ChatMessagesLoaded(existingChatMessageList);
    } else {
      List<ChatMessage> existingChatMessageList = [];

      if (!isObjectEmpty(updatedChatMessageList)) {
        existingChatMessageList.addAll(updatedChatMessageList);
      }

      if (!isObjectEmpty(updateChatMessage)) {
        existingChatMessageList.removeWhere((existingChatMessage) => existingChatMessage.id == updateChatMessage.id);
        existingChatMessageList.add(updateChatMessage);
      }

      if (!isObjectEmpty(deletingChatMessage)) {
        existingChatMessageList.removeWhere((existingChatMessage) => existingChatMessage.id == deletingChatMessage.id);
      }

      yield ChatMessagesLoaded(existingChatMessageList);
    }
  }

  Stream<ChatMessageState> _removeAllChatMessagesEvent(RemoveAllChatMessagesEvent event) async* {
    chatMessageDBService.deleteAllChatMessages();
    yield ChatMessagesNotLoaded();
    functionCallback(event, true);
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event) && !isObjectEmpty(event.callback)) {
      event.callback(value);
    }
  }
}
