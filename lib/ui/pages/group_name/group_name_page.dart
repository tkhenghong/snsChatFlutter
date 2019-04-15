import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupNamePage extends StatefulWidget {
  final List<Contact> selectedContacts;

  GroupNamePage({this.selectedContacts});

  @override
  State<StatefulWidget> createState() {
    return new GroupNamePageState();
  }
}

class GroupNamePageState extends State<GroupNamePage> {
  @override
  Widget build(BuildContext context) {
    print("widget.selectedContacts.length.toString(): " + widget.selectedContacts.length.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('New Group'),
        ),
        body: Material(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          child: Text("T"),
                        ),
                        Container(
                          width: 250.0,
                          child: TextField(),
                        ),
                        Icon(Icons.tag_faces),
                      ],
                    ),
                    Text(
                      "Provide a group subject and optional group icon.",
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              Container(
                height: 450.0,
                child: ListView(
                  children: widget.selectedContacts.map((Contact contact) {
                    return Card(
                      child: Container(
                        width: 30.0,
                        height: 50.0,
                        child: Center(
                          child: Text("Text"),
                        ),
                      )
                    );
                  }).toList(),
                ),
              ),
//              Text("Here"),
//              Text("Here"),
//              Text("Here"),
//              Text("Here"),
//              Text("Here"),
//              Text("Here"),
//              Text("Here"),
            ],
          ),
        ));
  }
}
