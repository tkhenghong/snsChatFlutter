import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/rest_request.utils.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Not using it right now, currently testing it inside chat room page.
class WebSocketService {
  String webSocketUrl = globals.WEBSOCKET_URL;

  WebSocketChannel webSocketChannel;
  Stream<dynamic> webSocketStream;

  Future<Stream<dynamic>> connectWebSocket() async {
    Map<String, String> headers = await handleHTTPHeaders();

    webSocketChannel = IOWebSocketChannel.connect(webSocketUrl, headers: headers);
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
    if (!webSocketChannel.isNull) {
      return webSocketChannel.sink.close();
    }
  }

  Future<Stream<dynamic>> reconnectWebSocket() async {
    await closeWebSocket();
    return connectWebSocket();
  }

  Future<Map<String, String>> handleHTTPHeaders() async {
    Map<String, String> headers = createAcceptJSONHeader();

    String jwt = await _readJWT();

    if (!jwt.isNullOrBlank) {
      headers.putIfAbsent('Authorization', () => 'Bearer $jwt');
    }

    return headers;
  }

  Future<String> _readJWT() async {
    final FlutterSecureStorage flutterSecureStorage = Get.find();
    return await flutterSecureStorage.read(key: "jwtToken");
  }
}
