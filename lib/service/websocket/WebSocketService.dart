import 'dart:collection';
import 'dart:convert';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Not using it right now, currently testing it inside chat room page.
class WebSocketService {
  String WEBSOCKET_URL = globals.WEBSOCKET_URL;

  WebSocketChannel webSocketChannel;
  Stream<dynamic> webSocketStream;

  Future<Stream<dynamic>> connectWebSocket(String userId, {String jwtToken}) async {
    Map<String, String> headers = new HashMap();
    headers['userId'] = userId;
    webSocketChannel = IOWebSocketChannel.connect(WEBSOCKET_URL, headers: headers);
    webSocketStream = webSocketChannel.stream.asBroadcastStream();

    return webSocketStream;
  }

  Stream<dynamic> getWebSocketStream() {
    return webSocketStream;
  }

  sendWebSocketMessage(WebSocketMessage webSocketMessage) {
    print("json.encode(webSocketMessage.toJson()): " + json.encode(webSocketMessage.toJson()));
    webSocketChannel.sink.add(json.encode(webSocketMessage.toJson()));
  }

  Future<dynamic> closeWebSocket() async {
    if(!isObjectEmpty(webSocketChannel)) {
      return webSocketChannel.sink.close();
    }
  }

  Future<Stream<dynamic>> reconnnectWebSocket(String userId) async {
    await closeWebSocket();
    return connectWebSocket(userId);
  }
}
