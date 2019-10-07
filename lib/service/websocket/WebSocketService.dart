import 'dart:convert';

import 'package:snschat_flutter/objects/websocket/WebSocketMessage.dart';
import 'package:web_socket_channel/io.dart';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:web_socket_channel/web_socket_channel.dart';

// Not using it right now, currently testing it inside chat room page.
class WebSocketService {
  final IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://echo.websocket.org");
  String WEBSOCKET_URL = globals.WEBSOCKET_URL;

  WebSocketChannel webSocketChannel;
  Stream<dynamic> webSocketStream;

  connect() async {
    webSocketChannel = IOWebSocketChannel.connect(WEBSOCKET_URL);
    webSocketStream = webSocketChannel.stream.asBroadcastStream();
  }

  Stream<dynamic> getWebSocketStream() {
    return webSocketStream;
  }

  sendWebSocketMessage(WebSocketMessage webSocketMessage) {
    webSocketChannel.sink.add(json.encode(webSocketMessage.toJson()));
  }

  closeWebSocket() {
    webSocketChannel.sink.close();
  }



}