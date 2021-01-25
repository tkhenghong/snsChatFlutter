import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/rest_request.utils.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Using STOMP client plugin(https://pub.dev/packages/stomp_dart_client), and official IOWebSocketChannel(https://flutter.dev/docs/cookbook/networking/web-sockets).
class WebSocketService {
  EnvironmentGlobalVariables env = Get.find();

  WebSocketChannel webSocketChannel;

  StompClient stompClient;

  Stream<dynamic> webSocketStream;

  /********************************************************wWebSocket Official methods******************************************************************/

  /// Connect WebSocket using official methods.
  Future<Stream<dynamic>> connectWebSocketOfficial() async {
    Map<String, String> headers = await handleHTTPHeaders();

    webSocketChannel = IOWebSocketChannel.connect(env.WEBSOCKET_URL, headers: headers);
    webSocketStream = webSocketChannel.stream.asBroadcastStream();

    return webSocketStream;
  }

  /// Get connected WebSocket Stream.
  Stream<dynamic> getWebSocketOfficialStream() {
    return webSocketStream;
  }

  /// Close WebSocket.
  Future<dynamic> closeWebSocketOfficial() async {
    if (!isObjectEmpty(webSocketChannel)) {
      await webSocketChannel.sink.close();
      webSocketChannel = null;
    }
  }

  /// Reconnect WebSocket.
  Future<Stream<dynamic>> reconnectWebSocketOfficial() async {
    await closeWebSocketOfficial();
    return connectWebSocketOfficial();
  }

  /********************************************************wWebSocket Official methods END******************************************************************/

  /********************************************************wWebSocket Official methods******************************************************************/

  /// Connect WebSocket with STOMP Protocol.
  Future<StompClient> connectWebSocketWithStompClient({Function(dynamic) onWebSocketError, Function(StompFrame) onStompError, Function(String) onDebugMessage, Function(StompFrame) onDisconnect, Function onWebSocketDone}) async {
    Map<String, String> headers = await handleHTTPHeaders();

    try {
      stompClient = StompClient(
          config: StompConfig(
              useSockJS: false,
              reconnectDelay: 3000,
              connectionTimeout: Duration(seconds: 5),
              url: env.WEBSOCKET_URL,
              onWebSocketError: onWebSocketError,
              onStompError: onStompError,
              onDebugMessage: onDebugMessage,
              onDisconnect: onDisconnect,
              onWebSocketDone: onWebSocketDone,
              stompConnectHeaders: headers,
              webSocketConnectHeaders: headers));

      stompClient.activate();
    } catch (e) {
      showToast('Error in connecting WebSocket. Please try again later.', Toast.LENGTH_LONG);
    }

    return stompClient;
  }

  /// Subscribe to STOMP topic, after the WebSocket connection is established.
  subscribeToSTOMPTopic(String stompTopic, StompClient client, Function(StompFrame) callback) {
    client.subscribe(
      destination: stompTopic,
      callback: callback,
    );
  }

  /// Get STOMPClient object after subscribed STOMP topic to listen to events.
  StompClient getStompClient() {
    return stompClient;
  }

  /// Close WebSocket STOMP client.
  Future<void> closeWebSocketSTOMPClient() async {
    if (!isObjectEmpty(stompClient)) {
      stompClient.deactivate();
      stompClient = null;
    }
  }

  /// Prepare headers for WebSocket/STOMP connections.
  Future<Map<String, String>> handleHTTPHeaders() async {
    Map<String, String> headers = createAcceptJSONHeader();

    String jwt = await _readJWT();

    if (!isStringEmpty(jwt)) {
      headers.putIfAbsent('Authorization', () => 'Bearer $jwt');
    }

    return headers;
  }

  /// Get JWT token from Secure Storage plugin.
  Future<String> _readJWT() async {
    final FlutterSecureStorage flutterSecureStorage = Get.find();
    return await flutterSecureStorage.read(key: 'jwtToken');
  }
}
