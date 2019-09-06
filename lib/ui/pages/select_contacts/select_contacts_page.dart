import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Import package
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/chat/conversation_member.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:snschat_flutter/ui/pages/group_name/group_name_page.dart';

class SelectContactsPage extends StatefulWidget {
  final String chatGroupType;

  SelectContactsPage({this.chatGroupType});

  @override
  State<StatefulWidget> createState() {
    return new SelectContactsPageState();
  }
}

class SelectContactsPageState extends State<SelectContactsPage> {
  bool isLoading = true;
  bool contactLoaded = false;
  WholeAppBloc wholeAppBloc;
  PermissionStatus permissionStatus;
  List<Contact> selectedContacts = [];
  Map<String, bool> contactCheckBoxes = {};
  String title = "";
  String subtitle = "";
  RefreshController _refreshController;
  ScrollController scrollController = new ScrollController();

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
    scrollController = new ScrollController();
  }

  setupCheckBoxes() {
    // Set up checkboxes first
    wholeAppBloc.currentState.phoneContactList.forEach((contact) {
      contactCheckBoxes[contact.displayName] = false;
      contactLoaded = true;
    });
  }

  getContacts() async {
    if (wholeAppBloc.currentState.phoneContactList.length == 0) {
      wholeAppBloc.dispatch(GetPhoneStorageContactsEvent(callback: (bool getContactsSuccess) {
        if (getContactsSuccess) {
          // Set up checkboxes first
          setupCheckBoxes();
          // Rerender the page
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }));
    } else if (!contactLoaded) {
      // need to add _wholeAppBloc.currentState.phoneContactList.length == 0 together
      setupCheckBoxes();
      setState(() {
        isLoading = false;
      });
    }
  }

  setConversationType(String chatGroupType) async {
    print("widget.chatGroupType: " + widget.chatGroupType);
    switch (chatGroupType) {
      case "Personal":
        title = "Create Personal Chat";
        subtitle = "Select a contact below.";
        break;
      case "Group":
        title = "Create Group Chat";
        subtitle = "Select a few contacts below.";
        break;
      case "Broadcast":
        title = "Broadcast";
        subtitle = "Select a few contacts below.";
        break;
      default:
        title = "Unknown Chat";
        subtitle = "Error. Please go back and select again.";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;

    if (isLoading) {
      getContacts();
      setConversationType(widget.chatGroupType);
    }

    return new Scaffold(
        appBar: new AppBar(
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
                    title,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    subtitle,
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
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => GroupNamePage(selectedContacts: selectedContacts))));
                },
              ),
            ),
          ],
        )),
        body: isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Reading contacts from storage....'),
                  SizedBox(
                    height: 10.0,
                  ),
                  CircularProgressIndicator(),
                ],
              ))
            : wholeAppBloc.currentState.phoneContactList.length > 0
                ? BlocBuilder(
                    bloc: _wholeAppBloc,
                    builder: (context, WholeAppState state) {
                      return ListView(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        children: state.phoneContactList.map((Contact contact) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                needSelectMultipleContacts()
                                    ? CheckboxListTile(
                                        title: Text(
                                          contact.displayName,
                                          softWrap: true,
                                        ),
                                        subtitle: Text(
                                          'Hey There! I am using PocketChat.',
                                          softWrap: true,
                                        ),
                                        value: contactCheckBoxes[contact.displayName],
                                        onChanged: (bool value) {
                                          if (contactIsSelected(contact)) {
                                            selectedContacts.remove(contact);
                                          } else {
                                            selectedContacts.add(contact);
                                          }
                                          setState(() {
                                            contactCheckBoxes[contact.displayName] = value;
                                          });
                                        },
                                        secondary: CircleAvatar(
                                          backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
                                          child: contact.avatar.isEmpty ? Text(contact.displayName[0]) : Text(''),
                                          radius: 20.0,
                                        ),
                                      )
                                    : ListTile(
                                        title: Text(
                                          contact.displayName,
                                          softWrap: true,
                                        ),
                                        subtitle: Text(
                                          'Hey There! I am using PocketChat.',
                                          softWrap: true,
                                        ),
                                        onTap: () {
                                          createPersonalConversation(contact).then((conversationGroup) {
                                            _wholeAppBloc.dispatch(AddConversationGroupEvent(conversationGroup: conversationGroup));
                                            Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversationGroup))));
                                          });
                                        },
                                        leading: CircleAvatar(
                                          backgroundImage: contact.avatar.isNotEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
                                          child: contact.avatar.isEmpty ? Text(contact.displayName[0]) : Text(''),
                                          radius: 20.0,
                                        ),
                                      )
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Unable to read contacts from storage. Please grant contact permission first.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          // Restart the process
                          setState(() {
                            isLoading = true;
                          });
                        },
                        child: Text("Grant Contact Permission"),
                      )
                    ],
                  )));
  }

  bool contactIsSelected(Contact contact) {
    return selectedContacts.any((Contact selectedContact) => selectedContact.displayName == contact.displayName);
  }

  bool needSelectMultipleContacts() {
//    return widget.chatGroupType == ChatGroupType.Group || widget.chatGroupType == ChatGroupType.Broadcast;
    return widget.chatGroupType == "Group" || widget.chatGroupType == "Broadcast";
  }

  // TODO: Conversation Group Creation into BLOC, can be merged with Group & Broadcast
  Future<ConversationGroup> createPersonalConversation(Contact contact) async {

    List<Contact> contactList = [];
    contactList.add(contact);

    print("createPersonalConversation()");
    ConversationGroup conversationGroup = new ConversationGroup(
      id: null,
      creatorUserId: wholeAppBloc.currentState.userState.id,
      createdDate: new DateTime.now().millisecondsSinceEpoch.toString(),
      name: contact.displayName,
      type: "Personal",
      block: false,
      description: '',
      adminMemberIds: [],
      memberIds: [],
      // memberIds put UserContact.id. NOT User.id
      notificationExpireDate: 0,
    );
    // TODO: Check your UserContact exist in backend database or not first. (DONE)

    Multimedia groupMultiMedia = Multimedia(
        id: null,
        imageDataId: null,
        imageFileId: null,
        localFullFileUrl: null,
        localThumbnailUrl: null,
        remoteThumbnailUrl: null,
        remoteFullFileUrl: null,
        userContactId: null,
        conversationId: null, // Add the conversationId after the conversationGroup object is created in the backend
        messageId: null);

    // In Malaysia,
    // If got +60, remove +60.
    // If got 012285...
    // Remove the 1st 0 out of the number
    // When user sign up, make sure:
    // Get the Country code to identify the user country origin.
    // Remove the international code to get significant phone number of the user
    // After sign up, send a command at the backend to replace those UserContact object with exactly same number

    print("Before CreateConversationGroupEvent");
    wholeAppBloc.dispatch(CreateConversationGroupEvent(multimedia: groupMultiMedia, contactList: contactList, conversationGroup: conversationGroup, type: "Single", callback: (bool conversationGroupCreated){
      if(conversationGroupCreated) {
        print("Conversation Group Created.");
      } else {
        print("Conversation Group Failed.");
      }
    }));
    return conversationGroup;
//    uploadConversation(conversationGroup, newUnreadMessage, groupMultiMedia);
  }

  uploadConversation(ConversationGroup conversationGroup, UnreadMessage newUnreadMessage, Multimedia groupMultiMedia) async {
    print("uploadConversation()");
    await Firestore.instance.collection('conversation').document(conversationGroup.id).setData({
      'id': conversationGroup.id,
      'name': conversationGroup.name,
      'type': conversationGroup.type,
      'creatorUserId': conversationGroup.creatorUserId,
      'createdDate': conversationGroup.createdDate,
      'block': conversationGroup.block,
      'description': conversationGroup.description,
      'notificationExpireDate': conversationGroup.notificationExpireDate,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    print("Upload group conversation successful.");
    await Firestore.instance.collection('unreadMessage').document(newUnreadMessage.id).setData({
      'id': newUnreadMessage.id,
      'count': newUnreadMessage.count,
      'date': newUnreadMessage.date,
      'lastMessage': newUnreadMessage.lastMessage,
    });

    print("Upload unreadMessage success!");

    wholeAppBloc.dispatch(OverrideUnreadMessageEvent(unreadMessage: newUnreadMessage, callback: (UnreadMessage unreadMessage) {}));

    await Firestore.instance.collection('multimedia').document(newUnreadMessage.id).setData({
      'id': groupMultiMedia.id,
      'imageDataId': groupMultiMedia.imageDataId,
      'imageFileId': groupMultiMedia.imageFileId,
      'localFullFileUrl': groupMultiMedia.localFullFileUrl,
      'localThumbnailUrl': groupMultiMedia.localThumbnailUrl,
      'remoteThumbnailUrl': groupMultiMedia.remoteThumbnailUrl,
      'remoteFullFileUrl': groupMultiMedia.remoteFullFileUrl,
      'messageId': groupMultiMedia.messageId,
      'userContactId': groupMultiMedia.userContactId,
      'conversationId': groupMultiMedia.conversationId,
    });

    print("Upload multimedia success!");
    wholeAppBloc.dispatch(AddMultimediaEvent(callback: (Multimedia multimedia) {}, multimedia: groupMultiMedia));

    //TODO: Check user_contact
  }

  // Find the group member that the user added into the conversation using his/her phone number
  // If found, return that edited UserContact object
  // If not found, return NOT edited UserContact object
  Future<UserContact> findUserContact(UserContact newUserContact) async {
    var conversationDocuments =
        await Firestore.instance.collection("user").where("mobileNo", isEqualTo: newUserContact.mobileNo).getDocuments();
    if (conversationDocuments.documents.length > 0) {
      print("if (conversationDocuments.documents.length > 0)");
      print("conversationDocuments.documents.length.toString(): " + conversationDocuments.documents.length.toString());
      DocumentSnapshot documentSnapshot = conversationDocuments.documents[0];
      newUserContact.mobileNo = documentSnapshot["mobileNo"];
      return newUserContact;
    } else {}
  }
}
