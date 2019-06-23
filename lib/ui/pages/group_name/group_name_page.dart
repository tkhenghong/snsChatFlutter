import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/objects/user/user.dart';
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
                  createGroupConversation().then((conversation) {
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
  Future<Conversation> createGroupConversation() async {
    Conversation conversation = new Conversation(
      id: generateNewId().toString(),
      notificationExpireDate: 0,
      creatorUserId: wholeAppBloc.currentState.userState.id,
      createdDate: new DateTime.now().millisecondsSinceEpoch.toString(),
      name: textEditingController.text,
      type: "Group",
      block: false,
      description: '',
    );

    // Multimedia for group chat
    Multimedia newMultiMedia = Multimedia(
      id: generateNewId().toString(),
      imageDataId: "",
      imageFileId: "",
      localFullFileUrl: imageFile.path,
      localThumbnailUrl: null,
      remoteThumbnailUrl: null,
      remoteFullFileUrl: null,
      messageId: "",
      userContactId: "",
      conversationId: conversation.id,
    );
    wholeAppBloc.dispatch(AddMultimediaEvent(callback: (Multimedia multimedia) {}, multimedia: newMultiMedia));

    UnreadMessage newUnreadMessage = UnreadMessage(
        id: generateNewId().toString(),
        conversationId: conversation.id,
        count: 0,
        date: 0,
        lastMessage: "",
        userId: wholeAppBloc.currentState.userState.id);

    uploadConversationMembers(conversation);

    // Upload yourself as UserContact as you're the one of the group member in the conversation
    uploadSelfUserContact(conversation);

    uploadConversation(conversation, newUnreadMessage, newMultiMedia);

    return conversation;
  }

  uploadConversationMembers(Conversation conversation) async {
    print("group_name_page.dart uploadConversationMembers()");
    // convert contact to contact (self defined)
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
      } else {
        print('if (contact.avatar.length <= 0)');
      }
      // contact, primaryNo, conversation
      UserContact newUserContact = UserContact(
        id: generateNewId().toString(),
        userId: "",
        // TODO: Should be matching database ID? Or frontend UserId?
        displayName: contact.displayName,
        realName: contact.displayName,
        // In case of mobile number only contact, mobile no equals to contact.displayName
        mobileNo: primaryNo.length == 0 ? contact.displayName : primaryNo[0],
        block: false,
        lastSeenDate: "",
        conversationId: conversation.id,
      );
      uploadUserContact(newUserContact).then((UserContact userContact) {
        wholeAppBloc.dispatch(AddUserContactEvent(callback: (UserContact userContact) {}, userContact: newUserContact));
      }); // Should check whether success or not first by .then()
    });
  }

  Future<UserContact> uploadUserContact(UserContact newUserContact) async {
    print("group_name_page.dart uploadUserContact()");
    // Upload the group member's mobile no to User no. to find a match
    QuerySnapshot userSnapshots =
        await Firestore.instance.collection("user").where("mobileNo", isEqualTo: newUserContact.mobileNo).getDocuments();
    List<DocumentSnapshot> userDocuments = userSnapshots.documents;
    print("userDocuments.length: " + userDocuments.length.toString());
    if (userDocuments.length > 0) {
      print("if(userDocuments.length > 0)");
      newUserContact.userId = userDocuments[0]['id'];
    } else {
      print("if(userDocuments.length == 0)");
    }

    Firestore.instance.collection('user_contact').document(newUserContact.id).setData({
      'id': newUserContact.id,
      'userId': newUserContact.userId,
      'displayName': newUserContact.displayName,
      'realName': newUserContact.realName,
      'mobileNo': newUserContact.mobileNo,
      'block': newUserContact.block,
      'lastSeenDate': newUserContact.lastSeenDate,
      'conversationId': newUserContact.conversationId
    });

    return newUserContact;
  }

  uploadSelfUserContact(Conversation conversation) async {
    print("group_name_page.dart uploadSelfUserContact()");
    User currentUser = wholeAppBloc.currentState.userState;
    UserContact selfUserContact = UserContact(
      id: generateNewId().toString(),
      userId: currentUser.id,
      // Upload self id from User table
      displayName: currentUser.displayName,
      realName: currentUser.realName,
      mobileNo: currentUser.mobileNo,
      block: false,
      lastSeenDate: "",
      conversationId: conversation.id,
    );

    uploadUserContact(selfUserContact); // Should check whether success or not first by .then()
    wholeAppBloc.dispatch(AddUserContactEvent(callback: (UserContact userContact) {}, userContact: selfUserContact));
  }

  uploadConversation(Conversation conversation, UnreadMessage newUnreadMessage, Multimedia newMultiMedia) async {
    print("group_name_page.dart uploadConversation()");
    await Firestore.instance.collection('conversation').document(conversation.id).setData({
      'id': conversation.id, // Self generated Id
      'name': conversation.name,
      'type': conversation.type,
      'creatorUserId': conversation.creatorUserId,
      'createdDate': conversation.createdDate,
      'block': conversation.block,
      'description': conversation.description,
      'notificationExpireDate': conversation.notificationExpireDate,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    print("Upload group conversation successful.");
    await Firestore.instance.collection('unreadMessage').document(newUnreadMessage.id).setData({
      'id': newUnreadMessage.id,
      'count': newUnreadMessage.count,
      'date': newUnreadMessage.date,
      'lastMessage': newUnreadMessage.lastMessage,
      'conversationId': newUnreadMessage.conversationId,
      'userId': newUnreadMessage.userId
    });

    print("Upload unreadMessage success!");

    wholeAppBloc.dispatch(OverrideUnreadMessageEvent(unreadMessage: newUnreadMessage, callback: (UnreadMessage unreadMessage) {}));

    await Firestore.instance.collection('multimedia').document(newUnreadMessage.id).setData({
      'id': newMultiMedia.id,
      'imageDataId': newMultiMedia.imageDataId,
      'imageFileId': newMultiMedia.imageFileId,
      'localFullFileUrl': newMultiMedia.localFullFileUrl,
      'localThumbnailUrl': newMultiMedia.localThumbnailUrl,
      'remoteThumbnailUrl': newMultiMedia.remoteThumbnailUrl,
      'remoteFullFileUrl': newMultiMedia.remoteFullFileUrl,
      'messageId': newMultiMedia.messageId,
      'userContactId': newMultiMedia.userContactId,
      'conversationId': newMultiMedia.conversationId,
    });

    print("Upload multimedia success!");
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
