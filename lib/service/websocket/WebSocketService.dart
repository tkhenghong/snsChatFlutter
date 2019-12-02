import 'dart:convert';

import 'package:snschat_flutter/objects/websocket/WebSocketMessage.dart';
import 'package:web_socket_channel/io.dart';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:web_socket_channel/web_socket_channel.dart';

// Not using it right now, currently testing it inside chat room page.
class WebSocketService {
  String WEBSOCKET_URL = globals.WEBSOCKET_URL;

  WebSocketChannel webSocketChannel;
  Stream<dynamic> webSocketStream;

  connectWebSocket() async {
    webSocketChannel = IOWebSocketChannel.connect(WEBSOCKET_URL);
    webSocketStream = webSocketChannel.stream.asBroadcastStream();
  }

  Stream<dynamic> getWebSocketStream() {
    return webSocketStream;
  }

  sendWebSocketMessage(WebSocketMessage webSocketMessage) {
    print("json.encode(webSocketMessage.toJson()): " + json.encode(webSocketMessage.toJson()));
    webSocketChannel.sink.add(json.encode(webSocketMessage.toJson()));
  }

  closeWebSocket() {
    webSocketChannel.sink.close();
  }

  reconnnectWebSocket() {
    closeWebSocket();
    connectWebSocket();
  }
}
