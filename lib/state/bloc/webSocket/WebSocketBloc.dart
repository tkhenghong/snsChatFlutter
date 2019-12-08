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
    }
  }

  Stream<WebSocketState> _initializeWebSocketToState(InitializeWebSocketEvent event) async* {
    try {
      webSocketService.connectWebSocket();

      functionCallback(event, true);
      yield WebSocketLoaded(webSocketService.getWebSocketStream());
    } catch (e) {
      functionCallback(event, false);
      yield WebSocketNotLoaded();
    }
  }

  Stream<WebSocketState> _reconnectWebSocket(ReconnectWebSocketEvent event) async* {

    if (state is WebSocketLoaded) {
      webSocketService.reconnnectWebSocket();

      yield WebSocketLoaded(webSocketService.getWebSocketStream());
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

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
