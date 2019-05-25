import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
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
  File imageFile;
  bool imageExists = false;
  WholeAppBloc wholeAppBloc;

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
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
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
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
                  addGroupConversation().then((conversation) {
                    print("Go back to Main Page!");
                    _wholeAppBloc.dispatch(AddConversationEvent(conversation: conversation));
                    Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversation))));
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
                              //TODO: Add group photo from gallery/ take photo
//                              showOptionsDialog(context);
                              getImage();
                            },
                            borderRadius: BorderRadius.circular(20.0),
                            child: CircleAvatar(
                              backgroundImage: imageExists ? FileImage(imageFile) : AssetImage('lib/ui/icons/default_blank_photo.png'),
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
                              style: TextStyle(color: Colors.grey, fontSize: 12.0),
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
                    "Group Members: " + widget.selectedContacts.length.toString(),
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
                                  backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
                                  child: contact.avatar.isEmpty ? Text(contact.displayName[0]) : Text(''),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[Text(contact.displayName, overflow: TextOverflow.ellipsis)],
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

  // TODO: Conversation Creation into BLOC, can be merged with Personal & Broadcast
  Future<Conversation> addGroupConversation() async {
    Conversation conversation = new Conversation();
    int newId = generateNewId();
    conversation.id = newId.toString();
    conversation.name = textEditingController.text;

    Multimedia newMultiMedia = Multimedia(
        id: generateNewId().toString(),
        imageDataId: "",
        imageFileId: "",
        localFullFileUrl: imageFile.path,
        localThumbnailUrl: null,
        remoteThumbnailUrl: null,
        remoteFullFileUrl: null);
    UnreadMessage newUnreadMessage = UnreadMessage(id: generateNewId().toString(), count: 0, date: 0, lastMessage: "");
    wholeAppBloc.dispatch(OverrideUnreadMessageEvent(unreadMessage: newUnreadMessage, callback: (UnreadMessage unreadMessage) {}));
    // convert contact to contact (self defined)
    List<UserContact> userContacts = [];
    widget.selectedContacts.forEach((contact) {
      //Determine how many phone number he has
      List<String> primaryNo = [];
      if (contact.phones.length > 0) {
        contact.phones.forEach((phoneNo) {
          primaryNo.add(phoneNo.value);
        });
      }

      // Create new Multimedia object to save photo
      if (contact.avatar.length > 0) {
        print('if (contact.avatar.length > 0)');
        // Multimedia newMultimedia = Multimedia(imageData: contact.avatar);
//        wholeAppBloc.dispatch(AddMultimediaEvent(callback: (Multimedia multimedia) {}, multimedia: newMultiMedia));
      } else {
        print('if (contact.avatar.length <= 0)');
      }
      // Will add a default Multimedia object to the state list and DB no matter it's empty or not, to prevent any null event happens
      wholeAppBloc.dispatch(AddMultimediaEvent(callback: (Multimedia multimedia) {}, multimedia: newMultiMedia));

      userContacts.add(UserContact(
        id: generateNewId().toString(),
        userId: generateNewId().toString(),
        // TODO: Should be matching database ID? Or frontend UserId?
        displayName: contact.displayName,
        realName: contact.displayName,
        mobileNo: primaryNo.length == 0 ? "" : primaryNo[0],
        // Give the first number they from a list of numbers
        // photo: Multimedia(imageData: contact.avatar),
        // photoId: Multimedia(imageData: contact.avatar),
        photoId: newMultiMedia.id,
      ));
    });
    conversation.type = ChatGroupType.Group;
    conversation.contacts = userContacts;
    conversation.block = false;
    conversation.description = '';
    conversation.groupPhotoId = newMultiMedia.id;
    conversation.unreadMessageId = newUnreadMessage.id;

    // Multimedia(remoteUrl: "", localUrl: _image.path, imageData: await _image.readAsBytes(), imageFile: _image, thumbnail: "");

    return conversation;
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (await image.exists()) {
      imageExists = true;
    }
    setState(() {
      imageFile = image;
    });
  }
}
