import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/general/ui-component/select_image.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';

import 'package:image_picker/image_picker.dart';

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
  File _image;
  bool imageExists = false;

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
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
                  addConversation().then((conversation) {
                    _wholeAppBloc.dispatch(AddConversationEvent(conversation: conversation));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        'tabs_page', (Route<dynamic> route) => false);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ChatRoomPage(conversation))));
                  });
                },
              ),
            ),
          ],
        )),
        body: Container(
          child: Material(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 50.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: 65.0,
                          width: 65.0,
                          child: InkWell(
                            onTap: () {
                              //TODO: Add group photo
//                              showOptionsDialog(context);
                              getImage();
                            },
                            borderRadius: BorderRadius.circular(20.0),
                            child: CircleAvatar(
                              backgroundImage: imageExists
                                  ? FileImage(_image)
                                  : AssetImage(
                                      'lib/ui/icons/default_blank_photo.png'),
                            ),
                          )),
                      Container(
                        width: 230.0,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: textEditingController,
                            ),
                            Text(
                              "Provide a group subject and optional group icon.",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                      Icon(Icons.tag_faces),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0),
                  child: Text(
                    "Group Members: " +
                        widget.selectedContacts.length.toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  height: 380.0,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: widget.selectedContacts.map((Contact contact) {
                      return Card(
                          elevation: 5.0,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Row(children: [
                                CircleAvatar(
                                  backgroundImage: contact.avatar.isNotEmpty
                                      ? MemoryImage(contact.avatar)
                                      : NetworkImage(''),
                                  child: contact.avatar.isEmpty
                                      ? Text(contact.displayName[0])
                                      : Text(''),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(contact.displayName,
                                          overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  int generateNewId() {
    var random = new Random();
    // Formula: random.nextInt((max - min) + 1) + min;
    int newId = random.nextInt((999999999 - 100000000) + 1) + 100000000;
    return newId;
  }

  Future<Conversation> addConversation() async {
    Conversation conversation = new Conversation();
    int newId = generateNewId();
    conversation.id = newId.toString();
    conversation.name = textEditingController.text;

    // convert contact to contact (self defined)
    List<UserContact> userContacts = [];
    widget.selectedContacts.forEach((contact) {
      //Determine how many phone number he has
      List<String> primaryNo = [];
      if (contact.phones.length > 0) {
        contact.phones.forEach((phoneNo) {
          print('phoneNo.label: ' + phoneNo.label);
          print('phoneNo.value: ' + phoneNo.value);
          primaryNo.add(phoneNo.value);
        });
      }

      userContacts.add(UserContact(
        id: generateNewId().toString(),
        userId: generateNewId().toString(),
        // TODO: Should be matching database ID? Or frontend UserId?
        displayName: contact.displayName,
        realName: contact.displayName,
        mobileNo: primaryNo.length == 0 ? "" : primaryNo[0],
        // Give the first number they from a list of numbers
        photo: Multimedia(imageData: contact.avatar),
      ));
    });
    conversation.type = ChatGroupType.Group;
    conversation.contacts = userContacts;
    conversation.block = false;
    conversation.description = '';
    conversation.groupPhoto = Multimedia(
        imageData: null, localUrl: null, remoteUrl: null, thumbnail: null);
    conversation.unreadMessage = UnreadMessage(
      count: 0, date: 0, lastMessage: ""
    );
    conversation.groupPhoto = Multimedia(
      remoteUrl: "",
      localUrl: _image.path,
      imageData: await _image.readAsBytes(),
      imageFile: _image,
      thumbnail: ""
    );

    return conversation;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (await image.exists()) {
      imageExists = true;
    }
    setState(() {
      _image = image;
    });
  }
}
