import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  final IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://echo.websocket.org");

  test() async {
    print("WebsocketService test()");
    StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          print("WebsocketService if(snapshot.hasData)");
          print("snapshot.data: " + snapshot.data);

//          channel.sink.add("Message sent back to Websocket server");

          return Text(snapshot.data);
        } else {
          print("WebsocketService if(!snapshot.hasData)");
          return Text("No data");
        }
      },
    );

    print("Second type of Listen");
    channel.stream.listen((message) {
        print("Channel connected.");
        print("message: " + message.toString());
    });

    channel.sink.add("Testing message");
  }

}