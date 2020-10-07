import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

import 'bloc.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketBloc() : super(WebSocketLoading());

  ConversationGroupBloc conversationGroupBloc;
  ChatMessageBloc chatMessageBloc;
  MultimediaBloc multimediaBloc;
  UnreadMessageBloc unreadMessageBloc;
  UserContactBloc userContactBloc;
  SettingsBloc settingsBloc;
  UserBloc userBloc;

  WebSocketService webSocketService = Get.find();

  @override
  Stream<WebSocketState> mapEventToState(WebSocketEvent event) async* {
    if (event is InitializeWebSocketEvent) {
      yield* _initializeWebSocketToState(event);
    } else if (event is DisconnectWebSocketEvent) {
      yield* _disconnectWebSocket(event);
    } else if (event is ReconnectWebSocketEvent) {
      yield* _reconnectWebSocket(event);
    } else if (event is GetOwnWebSocketEvent) {
      yield* _getOwnWebSocket(event);
    } else if (event is ProcessWebSocketMessageEvent) {
      yield* _processWebSocketMessageEvent(event);
    } else if (event is SendWebSocketMessageEvent) {
      yield* _sendWebSocketMessage(event);
    }
  }

  Stream<WebSocketState> _initializeWebSocketToState(InitializeWebSocketEvent event) async* {
    try {
      yield WebSocketLoaded(await webSocketService.connectWebSocket());
      functionCallback(event, true);
    } catch (e) {
      yield WebSocketNotLoaded();
      functionCallback(event, false);
    }
  }

  Stream<WebSocketState> _disconnectWebSocket(DisconnectWebSocketEvent event) async* {
    webSocketService.closeWebSocket();
    yield WebSocketNotLoaded();
    functionCallback(event, true);
  }

  Stream<WebSocketState> _reconnectWebSocket(ReconnectWebSocketEvent event) async* {
    if (state is WebSocketLoaded) {
      yield WebSocketLoaded(await webSocketService.reconnectWebSocket());
      functionCallback(event, true);
    } else {
      functionCallback(event, false);
    }
  }

  Stream<WebSocketState> _getOwnWebSocket(GetOwnWebSocketEvent event) async* {
    if (state is WebSocketLoaded) {
      Stream<dynamic> webSocketStream = (state as WebSocketLoaded).webSocketStream;

      functionCallback(event, webSocketStream);
    } else {
      functionCallback(event, null);
    }
  }

  Stream<WebSocketState> _processWebSocketMessageEvent(ProcessWebSocketMessageEvent event) async* {
    conversationGroupBloc =
        BlocProvider.of<ConversationGroupBloc>(event.context); // New Conversation Group event, Live Update conversation group event
    chatMessageBloc = BlocProvider.of<ChatMessageBloc>(event.context); // Live Update Chat Message event
    multimediaBloc = BlocProvider.of<MultimediaBloc>(event.context); // Live Update Multimedia event
    unreadMessageBloc = BlocProvider.of<UnreadMessageBloc>(event.context); // Live Update last unread message event
    userContactBloc = BlocProvider.of<UserContactBloc>(event.context); // Live Update new Group member enter/leave event
    settingsBloc = BlocProvider.of<SettingsBloc>(event.context);
    userBloc = BlocProvider.of<UserBloc>(event.context); // Used to determine Chat Message belongs to own user or other users.
    try {
      WebSocketMessage webSocketMessage = event.webSocketMessage;
      if (!isObjectEmpty(webSocketMessage)) {
        if (!isObjectEmpty(webSocketMessage.conversationGroup)) {
          processConversationGroup(webSocketMessage.conversationGroup);
        }

        if (!isObjectEmpty(webSocketMessage.message)) {
          processChatMessage(webSocketMessage.message);
        }

        if (!isObjectEmpty(webSocketMessage.multimedia)) {}

        if (!isObjectEmpty(webSocketMessage.unreadMessage)) {}

        if (!isObjectEmpty(webSocketMessage.settings)) {}

        if (!isObjectEmpty(webSocketMessage.user)) {}

        if (!isObjectEmpty(webSocketMessage.userContact)) {}
        functionCallback(event, true);
      } else {
        functionCallback(event, false);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<WebSocketState> _sendWebSocketMessage(SendWebSocketMessageEvent event) async* {
    if (state is WebSocketLoaded) {
      webSocketService.sendWebSocketMessage(event.webSocketMessage);

      functionCallback(event, true);
    } else {
      functionCallback(event, false);
    }
  }

  processConversationGroup(ConversationGroup conversationGroup) {
    // Conversation Group message
    conversationGroupBloc
        .add(AddConversationGroupEvent(conversationGroup: conversationGroup, callback: (ConversationGroup conversationGroup) {}));
  }

  processChatMessage(ChatMessage chatMessage) {
    UserState userState = userBloc.state;
    if (userState is UserLoaded) {
      if (userState.user.id != chatMessage.senderId) {
        // "Message" message
        chatMessageBloc.add(AddChatMessageEvent(message: chatMessage, callback: (ChatMessage message) {}));
        if (chatMessage.type == ChatMessageType.Audio || chatMessage.type == ChatMessageType.Image) {
          multimediaBloc.add(GetMessageMultimediaEvent(
              messageId: chatMessage.id, conversationGroupId: chatMessage.conversationId, callback: (Multimedia multimedia) {}));
        }
      } else {
        // Mark your own message as sent, received status will changed by recipient
        chatMessage.status = ChatMessageStatus.Sent;
        chatMessageBloc.add(EditChatMessageEvent(message: chatMessage, callback: (ChatMessage message) {}));
      }
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
