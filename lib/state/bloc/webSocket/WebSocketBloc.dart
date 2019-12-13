import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/service/websocket/WebSocketService.dart';

import 'bloc.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketService webSocketService = WebSocketService();

  @override
  WebSocketState get initialState => WebSocketLoading();

  @override
  Stream<WebSocketState> mapEventToState(WebSocketEvent event) async* {
    if (event is InitializeWebSocketEvent) {
      yield* _initializeWebSocketToState(event);
    } else if (event is ReconnectWebSocketEvent) {
      yield* _reconnectWebSocket(event);
    } else if (event is GetOwnWebSocketEvent) {
      yield* _getOwnWebSocket(event);
    } else if (event is SendWebSocketMessageEvent) {
      yield* _sendWebSocketMessage(event);
    }
  }

  Stream<WebSocketState> _initializeWebSocketToState(InitializeWebSocketEvent event) async* {
    try {
      webSocketService.connectWebSocket();

      yield WebSocketLoaded(webSocketService.getWebSocketStream());
      functionCallback(event, true);
    } catch (e) {
      yield WebSocketNotLoaded();
      functionCallback(event, false);
    }
  }

  Stream<WebSocketState> _reconnectWebSocket(ReconnectWebSocketEvent event) async* {

    if (state is WebSocketLoaded) {
      webSocketService.reconnnectWebSocket();

      yield WebSocketLoaded(webSocketService.getWebSocketStream());
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

  Stream<WebSocketState> _sendWebSocketMessage(SendWebSocketMessageEvent event) async* {
    if (state is WebSocketLoaded) {
      Stream<dynamic> webSocketStream = (state as WebSocketLoaded).webSocketStream;

      functionCallback(event, webSocketStream);
    } else {
      functionCallback(event, null);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
