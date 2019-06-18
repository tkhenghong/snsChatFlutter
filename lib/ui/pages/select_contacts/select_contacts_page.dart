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

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;
    print('_wholeAppBloc.currentState.phoneContactList.length: ' + _wholeAppBloc.currentState.phoneContactList.length.toString());
    if (_wholeAppBloc.currentState.phoneContactList.length == 0) {
      print('if(_wholeAppBloc.currentState.phoneContactList.length == 0)');
      _wholeAppBloc.dispatch(GetPhoneStorageContactsEvent(callback: () {
        // Set up checkboxes first
        setupCheckBoxes();
        // Rerender the page
        setState(() {
          isLoading = false;
        });
      }));
    } else if (!contactLoaded) {
      // need to add _wholeAppBloc.currentState.phoneContactList.length == 0 together
      setupCheckBoxes();
      setState(() {
        isLoading = false;
      });
    }

    print("widget.chatGroupType: " + widget.chatGroupType);
    switch (widget.chatGroupType) {
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

    print('contactCheckBoxes.length.toString(): ' + contactCheckBoxes.length.toString());
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
            : BlocBuilder(
                bloc: _wholeAppBloc,
                builder: (context, WholeAppState state) {
                  return ListView(
                    controller: scrollController,
                    physics: RefreshBouncePhysics(),
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
                                      createPersonalConversation(contact).then((conversation) {
                                        _wholeAppBloc.dispatch(AddConversationEvent(conversation: conversation));
                                        Navigator.of(context).pushNamedAndRemoveUntil('tabs_page', (Route<dynamic> route) => false);
                                        Navigator.push(context, MaterialPageRoute(builder: ((context) => ChatRoomPage(conversation))));
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
              ));
  }

  bool contactIsSelected(Contact contact) {
    return selectedContacts.any((Contact selectedContact) => selectedContact.displayName == contact.displayName);
  }

  bool needSelectMultipleContacts() {
//    return widget.chatGroupType == ChatGroupType.Group || widget.chatGroupType == ChatGroupType.Broadcast;
    return widget.chatGroupType == "Group" || widget.chatGroupType == "Broadcast";
  }

  // TODO: Conversation Creation into BLOC, can be merged with Group & Broadcast
  Future<Conversation> createPersonalConversation(Contact contact) async {
    Conversation conversation = new Conversation(
      id: generateNewId().toString(),
      userId: wholeAppBloc.currentState.userState.id,
      name: contact.displayName,
      type: "Personal",
      block: false,
      description: '',
    );
    UserContact newUserContact = UserContact(
      id: generateNewId().toString(),
      userId: generateNewId().toString(),
      // TODO: Should be matching database ID? Or frontend UserId?
      displayName: contact.displayName,
      realName: contact.displayName,
//      mobileNo: primaryNo.length == 0 ? "" : primaryNo[0], // Added in later code
    );

    ConversationMember conversationMember = ConversationMember(
      id: generateNewId().toString(),
      conversationId: conversation.id,
      name: newUserContact.displayName,
      contactNo: newUserContact.mobileNo,
    );

    Multimedia newMultiMedia = Multimedia(
        id: generateNewId().toString(),
        imageDataId: "",
        imageFileId: "",
        localFullFileUrl: "",
        localThumbnailUrl: "",
        remoteThumbnailUrl: "",
        remoteFullFileUrl: "",
        userContactId: newUserContact.id,
        messageId: "");
    UnreadMessage newUnreadMessage = UnreadMessage(id: generateNewId().toString(), count: 0, date: 0, lastMessage: "");

//    wholeAppBloc.dispatch(AddMultimediaEvent(callback: (Multimedia multimedia) {}, multimedia: newMultiMedia));
//    wholeAppBloc.dispatch(OverrideUnreadMessageEvent(unreadMessage: newUnreadMessage, callback: (UnreadMessage unreadMessage) {}));

    // Determine how many phone number he has
    List<String> primaryNo = [];
    if (contact.phones.length > 0) {
      contact.phones.forEach((phoneNo) {
        primaryNo.add(phoneNo.value);
      });
    }

    // Add mobile no to UserContact before save to state
    newUserContact.mobileNo = primaryNo.length == 0 ? "" : primaryNo[0];
    conversationMember.contactNo = newUserContact.mobileNo;

    // Personal chat one person only, so only dispatch once
//    wholeAppBloc
//        .dispatch(AddConversationMemberEvent(callback: (ConversationMember conversationMember) {}, conversationMember: conversationMember));
    wholeAppBloc.dispatch(AddUserContactEvent(callback: (UserContact userContact) {}, userContact: newUserContact));

    conversation.groupPhotoId = newMultiMedia.id;
    conversation.unreadMessageId = newUnreadMessage.id;
    print('newMultiMedia.id: ' + newMultiMedia.id);
    uploadConversation(conversation, conversationMember, newUnreadMessage, newMultiMedia);
    return conversation;
  }

  uploadConversation(
      Conversation conversation, ConversationMember conversationMember, UnreadMessage newUnreadMessage, Multimedia newMultiMedia) async {
    print("uploadConversation()");
    await Firestore.instance.collection('conversation').document(conversation.id).setData({
      'id': conversation.id, // Self generated Id
      'name': conversation.name,
      'type': conversation.type,
      'userId': conversation.userId,
      'groupPhotoId': conversation.groupPhotoId,
      'unreadMessageId': conversation.unreadMessageId,
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
    wholeAppBloc.dispatch(AddMultimediaEvent(callback: (Multimedia multimedia) {}, multimedia: newMultiMedia));

    await Firestore.instance.collection('conversation_member').document(conversationMember.id).setData({
      'id': conversationMember.id,
      'conversationId': conversationMember.conversationId,
      'name': conversationMember.name,
      'contactNo': conversationMember.contactNo,
    });
    print("Upload conversation_member success!");
    wholeAppBloc
        .dispatch(AddConversationMemberEvent(callback: (ConversationMember conversationMember) {}, conversationMember: conversationMember));

    //TODO: Check user_contact
  }
}
