import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/contact/contact.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';

class GroupNamePage extends StatefulWidget {
  final List<Contact> selectedContacts;

  GroupNamePage({this.selectedContacts});

  @override
  State<StatefulWidget> createState() {
    return new GroupNamePageState();
  }
}

class GroupNamePageState extends State<GroupNamePage> {
  TextEditingController textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("widget.selectedContacts.length.toString(): " +
        widget.selectedContacts.length.toString());
    return Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "New Group",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    "Select a contact",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
            Tooltip(
              message: "Next",
              child: InkWell(
                borderRadius: BorderRadius.circular(30.0),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(Icons.check),
                ),
                onTap: () {
                  print("Next Page!");
                  Conversation conversation = new Conversation();
                  int newId = generateNewId();
                  print('newId: ' + newId.toString());
                  conversation.id = newId.toString();
                  conversation.name = textEditingController.text;

                  // convert contact to contact (self defined)
                  List<UserContact> userContacts = [];
                  widget.selectedContacts.forEach((contact) {
                    //Determine how many phone number he has
                    List<String> primaryNo = [];
                    contact.phones.forEach((phoneNo) {
                      print('phoneNo: ' + phoneNo.toString());
                      primaryNo.add(phoneNo.toString());
                    });
                    userContacts.add(UserContact(
                      id: generateNewId().toString(),
                      userId: generateNewId().toString(),
                      // TODO: Should be matching database ID? Or frontend UserId?
                      displayName: contact.displayName,
                      realName: contact.displayName,
                      mobileNo: primaryNo.first,
                      // Give the first number they from a list of numbers
                      photo: Multimedia(imageData: contact.avatar),
                    ));
                  });
                  conversation.contacts = userContacts;

                  conversation.block = false;
                  conversation.description = '';
                  conversation.groupPhoto = Multimedia(
                      imageData: null,
                      localUrl: null,
                      remoteUrl: null,
                      thumbnail: null);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ChatRoomPage(conversation))));
                },
              ),
            ),
          ],
        )),
        body: Container(
            child: Material(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20.0, left: 30.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              height: 50.0,
                              width: 50.0,
                              child: InkWell(
                                onTap: () {
                                  //TODO: Add group photo
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                child: CircleAvatar(
                                  child: Text("T"),
                                ),
                              )),
                          Container(
                            width: 230.0,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                  controller: textEditingController,
                                ),
                                Text(
                                  "Provide a group subject and optional group icon.",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                          Icon(Icons.tag_faces),
                        ],
                      ),
                    ),
                    Text(
                      "Group Members: ",
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                    Container(
                        height: 450.0,
                        child: Container(
                          child: ListView(
                            children:
                                widget.selectedContacts.map((Contact contact) {
                              return Card(
                                  elevation: 5.0,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(children: [
                                        CircleAvatar(
                                          backgroundImage: contact.avatar !=
                                                  null
                                              ? MemoryImage(contact.avatar)
                                              : Text(contact.displayName[0]),
                                        ),
                                        Text(contact.displayName,
                                            overflow: TextOverflow.ellipsis),
                                      ]),
                                    ),
                                  ));
                            }).toList(),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  int generateNewId() {
    var random = new Random();
    // Formula: random.nextInt((max - min) + 1) + min;
    int newId =
        random.nextInt((999999999 - 100000000) + 1) + 100000000;
    return newId;
  }
}
