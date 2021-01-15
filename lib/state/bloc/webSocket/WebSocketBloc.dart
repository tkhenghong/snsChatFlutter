import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'bloc.dart';

class WebSocketBloc extends Bloc<WebSocketBlocEvent, WebSocketState> {
  WebSocketBloc() : super(WebSocketLoading());

  WebSocketService webSocketService = Get.find();

  @override
  Stream<WebSocketState> mapEventToState(WebSocketBlocEvent event) async* {
    if (event is ConnectOfficialWebSocketEvent) {
      yield* _connectOfficialWebSocket(event);
    } else if (event is DisconnectOfficialWebSocketEvent) {
      yield* _disconnectOfficialWebSocket(event);
    } else if (event is GetOfficialWebSocketStreamEvent) {
      yield* _getOfficialWebSocketStream(event);
    } else if (event is ProcessOfficialWebSocketMessageEvent) {
      yield* _processOfficialWebSocketMessageEvent(event);
    } else if (event is ConnectWebSocketWithSTOMPEvent) {
      yield* _connectWebSocketWithSTOMP(event);
    } else if (event is GetWebSocketSTOMPClientEvent) {
      yield* _getWebSocketSTOMPClient(event);
    } else if (event is SubscribeWebSocketSTOMPTopicEvent) {
      yield* _subscribeWebSocketSTOMPTopic(event);
    } else if (event is DisconnectWebSocketWithSTOMPEvent) {
      yield* _disconnectWebSocketWithSTOMP(event);
    }
  }

  /********************************************************wWebSocket Official Events******************************************************************/

  Stream<WebSocketState> _connectOfficialWebSocket(ConnectOfficialWebSocketEvent event) async* {
    try {
      if (state is OfficialWebSocketLoaded) {
        yield ReconnectingWebSocket();
        await webSocketService.closeWebSocketOfficial();
      }

      Stream<dynamic> onDataStream = await webSocketService.connectWebSocketOfficial();

      if (!isObjectEmpty(onDataStream)) {
        yield OfficialWebSocketLoaded(onDataStream);
        functionCallback(event, true);
      } else {
        yield WebSocketNotLoaded();
        functionCallback(event, false);
      }
    } catch (e) {
      yield WebSocketNotLoaded();
      functionCallback(event, false);
    }
  }

  Stream<WebSocketState> _disconnectOfficialWebSocket(DisconnectOfficialWebSocketEvent event) async* {
    webSocketService.closeWebSocketOfficial();
    yield WebSocketNotLoaded();
    functionCallback(event, true);
  }

  Stream<WebSocketState> _getOfficialWebSocketStream(GetOfficialWebSocketStreamEvent event) async* {
    if (state is OfficialWebSocketLoaded) {
      Stream<dynamic> webSocketStream = (state as OfficialWebSocketLoaded).webSocketStream;

      functionCallback(event, webSocketStream);
    } else {
      functionCallback(event, null);
    }
  }

  Stream<WebSocketState> _processOfficialWebSocketMessageEvent(ProcessOfficialWebSocketMessageEvent event) async* {
    print('WebSocketBloc.dart ProcessWebSocketMessageEvent');
    // conversationGroupBloc =
    //     BlocProvider.of<ConversationGroupBloc>(event.context); // New Conversation Group event, Live Update conversation group event
    // chatMessageBloc = BlocProvider.of<ChatMessageBloc>(event.context); // Live Update Chat Message event
    // multimediaBloc = BlocProvider.of<MultimediaBloc>(event.context); // Live Update Multimedia event
    // unreadMessageBloc = BlocProvider.of<UnreadMessageBloc>(event.context); // Live Update last unread message event
    // userContactBloc = BlocProvider.of<UserContactBloc>(event.context); // Live Update new Group member enter/leave event
    // settingsBloc = BlocProvider.of<SettingsBloc>(event.context);
    // userBloc = BlocProvider.of<UserBloc>(event.context); // Used to determine Chat Message belongs to own user or other users.
    // try {
    //   WebSocketMessage webSocketMessage = event.webSocketMessage;
    //   if (!webSocketMessage.isNull) {
    //     if (!webSocketMessage.conversationGroup.isNull) {
    //       processConversationGroup(webSocketMessage.conversationGroup);
    //     }
    //
    //     if (!webSocketMessage.message.isNull) {
    //       processChatMessage(webSocketMessage.message);
    //     }
    //
    //     if (!webSocketMessage.multimedia.isNull) {}
    //
    //     if (!webSocketMessage.unreadMessage.isNull) {}
    //
    //     if (!webSocketMessage.settings.isNull) {}
    //
    //     if (!webSocketMessage.user.isNull) {}
    //
    //     if (!webSocketMessage.userContact.isNull) {}
    //     functionCallback(event, true);
    //   } else {
    //     functionCallback(event, false);
    //   }
    // } catch (e) {
    //   functionCallback(event, false);
    // }
  }

  // processConversationGroup(ConversationGroup conversationGroup) {
  //   // Conversation Group message
  //   /// TODO: UpdateConversationGroupEvent to differentiate with AddConversationGroupEvent.
  //   // conversationGroupBloc
  //   //     .add(AddConversationGroupEvent(createConversationGroupRequest: CreateConversationGroupRequest(), callback: (ConversationGroup conversationGroup) {}));
  // }

  // processChatMessage(ChatMessage chatMessage) {
  //   UserState userState = userBloc.state;
  //   if (userState is UserLoaded) {
  //     if (userState.user.id != chatMessage.senderId) {
  //       chatMessageBloc.add(AddChatMessageEvent(createChatMessageRequest: CreateChatMessageRequest(conversationId: chatMessage.conversationId, messageContent: chatMessage.messageContent), callback: (ChatMessage message) {}));
  //
  //       /// TODO: Retrieve Chat message's Multimedia object, save it to the localDB and state.
  //       // if (chatMessage.type == MultimediaType.Audio || chatMessage.type == MultimediaType.Image) {
  //       //   multimediaBloc.add(GetMessageMultimediaEvent(
  //       //       messageId: chatMessage.id, conversationGroupId: chatMessage.conversationId, callback: (Multimedia multimedia) {}));
  //       // }
  //     } else {
  //       // Mark your own message as sent, received status will changed by recipient
  //       chatMessage.status = ChatMessageStatus.Sent;
  //       /// TODO: UpdateChatMessageEvent (Different than EditChatMessageEvent)
  //       // chatMessageBloc.add(EditChatMessageEvent(message: chatMessage, callback: (ChatMessage message) {}));
  //     }
  //   }
  // }
  /********************************************************wWebSocket Official Events END******************************************************************/

  /********************************************************wWebSocket STOMP Events START******************************************************************/

  Stream<WebSocketState> _connectWebSocketWithSTOMP(ConnectWebSocketWithSTOMPEvent event) async* {
    try {
      if (state is OfficialWebSocketSTOMPLoaded) {
        yield ReconnectingWebSocket();
        await webSocketService.closeWebSocketSTOMPClient();
      }

      StompClient stompClient = await connectWebSocketWithStompClient(event);

      if (!isObjectEmpty(stompClient)) {
        yield OfficialWebSocketSTOMPLoaded(stompClient);
        functionCallback(event, true);
      }
    } catch (e) {
      yield WebSocketNotLoaded();
      functionCallback(event, false);
    }
  }

  Stream<WebSocketState> _getWebSocketSTOMPClient(GetWebSocketSTOMPClientEvent event) async* {
    if (state is OfficialWebSocketSTOMPLoaded) {
      StompClient stompClient = (state as OfficialWebSocketSTOMPLoaded).stompClient;

      functionCallback(event, stompClient);
    } else {
      functionCallback(event, null);
    }
  }

  Stream<WebSocketState> _subscribeWebSocketSTOMPTopic(SubscribeWebSocketSTOMPTopicEvent event) async* {
    try {
      if (state is OfficialWebSocketSTOMPLoaded) {
        StompClient stompClient = (state as OfficialWebSocketSTOMPLoaded).stompClient;

        webSocketService.subscribeToSTOMPTopic('/secured/user/${event.userId}/notifications', stompClient, event.onMessage);
        functionCallback(event, true);
      } else {
        functionCallback(event, false);
      }
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<WebSocketState> _disconnectWebSocketWithSTOMP(DisconnectWebSocketWithSTOMPEvent event) async* {
    webSocketService.closeWebSocketSTOMPClient();
    yield WebSocketNotLoaded();
    functionCallback(event, true);
  }

  Future<StompClient> connectWebSocketWithStompClient(WebSocketBlocEvent event) async {
    return await webSocketService.connectWebSocketWithStompClient(
      onWebSocketError: (dynamic error) {},
      onStompError: (StompFrame stompFrame) {
        webSocketService.closeWebSocketSTOMPClient();
        if (event is ConnectWebSocketWithSTOMPEvent) {
          if (!isObjectEmpty(event.onWebSocketDone)) {
            event.onWebSocketDone();
          }
        }

        functionCallback(event, false);
      },
      onDebugMessage: (String debugMessage) {},
      onDisconnect: (StompFrame stompFrame) {},
      onWebSocketDone: () {
        webSocketService.closeWebSocketSTOMPClient();
        if (event is ConnectWebSocketWithSTOMPEvent) {
          if (!isObjectEmpty(event.onWebSocketDone)) {
            event.onWebSocketDone();
          }
        }
        functionCallback(event, false);
      },
    );
  }

  /********************************************************wWebSocket STOMP Events END******************************************************************/

  void functionCallback(event, value) {
    if (!isObjectEmpty(event) && !isObjectEmpty(event.callback)) {
      event.callback(value);
    }
  }
}
