import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/ui-component/loading.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
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
  List<UserContact> userContactList = [];
  FileService fileService;

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
                  createGroupConversation().then((conversationGroup) {
                    print("Go back to Main Page!");
                    _wholeAppBloc.dispatch(AddConversationGroupEvent(
                        conversationGroup: conversationGroup, callback: (ConversationGroup conversationGroup) {}));
                    Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
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

  // TODO: Conversation Group Creation into BLOC, can be merged with Personal & Broadcast
  // TODO: Review later to match code of Single Conversation Group creation in select_contacts_page.dart
  Future<ConversationGroup> createGroupConversation() async {
    print("createGroupConversation()");
    showLoading(context, "Loading conversation...");
    fileService = FileService();

    ConversationGroup conversationGroup = new ConversationGroup(
      id: null,
      notificationExpireDate: 0,
      creatorUserId: wholeAppBloc.currentState.userState.id,
      createdDate: new DateTime.now().millisecondsSinceEpoch,
      name: textEditingController.text,
      type: "Group",
      block: false,
      description: '',
      adminMemberIds: [],
      memberIds: []
    );
    print("conversationGroup: " + conversationGroup.toString());
    File copiedImageFile = null;
    if(!isStringEmpty(imageFile.path)) {
      copiedImageFile = await fileService.copyFile(imageFile, "ApplicationDocumentDirectory");
    }

    // Multimedia for group chat
    Multimedia groupMultiMedia = Multimedia(
      id: null,
      imageDataId: "",
      imageFileId: "",
      localFullFileUrl: isObjectEmpty(copiedImageFile) ? null : copiedImageFile.path,
      localThumbnailUrl: isObjectEmpty(copiedImageFile) ? null : copiedImageFile.path,
      remoteThumbnailUrl: null,
      remoteFullFileUrl: null,
      messageId: "",
      userContactId: "",
      conversationId: conversationGroup.id,
    );

    wholeAppBloc.dispatch(CreateConversationGroupEvent(
        multimedia: groupMultiMedia,
        contactList: widget.selectedContacts,
        conversationGroup: conversationGroup,
        type: "Group",
        callback: (ConversationGroup newConversationGroup) {
          print("CreateConversationGroupEvent callback success! ");
          Navigator.pop(context);
          if (newConversationGroup != null) {
            print("if(newConversationGroup != null)");
            Navigator.pop(context); //pop loading dialog
            Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
            Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(newConversationGroup))));
          } else {
            Fluttertoast.showToast(msg: 'Unable to create conversation group. Please try again.', toastLength: Toast.LENGTH_SHORT);
          }
        }));
    return conversationGroup;
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
