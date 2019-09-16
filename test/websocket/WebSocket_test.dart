import 'package:flutter_test/flutter_test.dart';
import 'package:snschat_flutter/service/websocket/WebSocketService.dart';

void main() {
  WebSocketService webSocketService = WebSocketService();
  test(("Test WebSocket Connection Configuration"), () async {
    webSocketService.test();
    Future.delayed(Duration(seconds: 10), () {
      print("Testing completed.");
    });

  });
}