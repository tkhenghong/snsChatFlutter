import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

import 'bloc.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketBloc(): super(WebSocketLoading());

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
    try {
      WebSocketMessage webSocketMessage = event.webSocketMessage;
      if (!isObjectEmpty(webSocketMessage)) {
        if (!isObjectEmpty(webSocketMessage.conversationGroup)) {
          // Conversation Group message
          BlocProvider.of<ConversationGroupBloc>(event.context).add(AddConversationGroupEvent(conversationGroup: webSocketMessage.conversationGroup, callback: (ConversationGroup conversationGroup) {}));
        }

        if (!isObjectEmpty(webSocketMessage.message)) {
          UserState userState = BlocProvider.of<UserBloc>(event.context).state;
          if (userState is UserLoaded) {
            if (userState.user.id != webSocketMessage.message.senderId) {
              // "Message" message
              BlocProvider.of<ChatMessageBloc>(event.context).add(AddChatMessageEvent(message: webSocketMessage.message, callback: (ChatMessage message) {}));
              if (webSocketMessage.message.type != 'Text' && webSocketMessage.message.type != 'Contact' && webSocketMessage.message.type != 'Location') {
                BlocProvider.of<MultimediaBloc>(event.context).add(GetMessageMultimediaEvent(messageId: webSocketMessage.message.id, conversationGroupId: webSocketMessage.message.conversationId, callback: (Multimedia multimedia) {}));
              }
            } else {
              // Mark your own message as sent, received status will changed by recipient
              webSocketMessage.message.status = ChatMessageStatus.Sent;
              BlocProvider.of<ChatMessageBloc>(event.context).add(EditChatMessageEvent(message: webSocketMessage.message, callback: (ChatMessage message) {}));
            }
          }
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
//      Stream<dynamic> webSocketStream = (state as WebSocketLoaded).webSocketStream;
      webSocketService.sendWebSocketMessage(event.webSocketMessage);

      functionCallback(event, true);
    } else {
      functionCallback(event, false);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
