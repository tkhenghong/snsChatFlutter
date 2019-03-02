import 'package:flutter/material.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

class ChatRoomPage extends StatefulWidget {
  Conversation conversation;
  ChatRoomPage({this.conversation});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChatRoomPageState();
  }

}

class ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new Scaffold(
      appBar: new AppBar(
        title: new Text('Chat Room'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Chat Room")
        ],
      ),
    );
  }

}