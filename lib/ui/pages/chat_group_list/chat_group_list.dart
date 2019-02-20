import 'package:flutter/material.dart';

class ChatGroupListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ChatGroupListState();
  }

}

class ChatGroupListState extends State<ChatGroupListPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  new Scaffold(
      appBar: new AppBar(
        title: new Text('Chats'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
          new ListTile(
            title: new Text('List Title'),
            subtitle: new Text('List subtitle'),
            trailing: new Text('trailling words'),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }

}