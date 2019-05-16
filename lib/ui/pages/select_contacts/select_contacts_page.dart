import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

// Import package
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:snschat_flutter/ui/pages/group_name/group_name_page.dart';

class SelectContactsPage extends StatefulWidget {
  final ChatGroupType chatGroupType;

  SelectContactsPage({this.chatGroupType});

  @override
  State<StatefulWidget> createState() {
    return new SelectContactsPageState();
  }
}

class SelectContactsPageState extends State<SelectContactsPage> {
  bool isLoading = true;
  bool contactLoaded = false;
  PermissionStatus permissionStatus;
  List<Contact> selectedContacts = [];
  Map<String, bool> contactCheckBoxes = {};
  String title = "";
  RefreshController _refreshController;
  ScrollController scrollController = new ScrollController();

  @override
  initState() {
    super.initState();
    _refreshController = new RefreshController();
    scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    if (!contactLoaded) {
      _wholeAppBloc.currentState.phoneContactList.forEach((contact) {
        contactCheckBoxes[contact.displayName] = false;
        contactLoaded = true;
      });
    }
    switch (widget.chatGroupType) {
      case ChatGroupType.Personal:
        title = "Create Personal Chat";
        break;
      case ChatGroupType.Group:
        title = "Create Group Chat";
        break;
      case ChatGroupType.Broadcast:
        title = "Broadcast";
        break;
      default:
        title = "Unknown Chat";
        break;
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
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => GroupNamePage(selectedContacts: selectedContacts))));
                },
              ),
            ),
          ],
        )),
        body: BlocBuilder(
          bloc: _wholeAppBloc,
          builder: (context, WholeAppState state) {
            return SmartRefresher(
              enablePullDown: false,
              controller: _refreshController,
              child: ListView(
                controller: scrollController,
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
                                  backgroundImage: !contact.avatar.isEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
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
                                  backgroundImage: !contact.avatar.isEmpty ? MemoryImage(contact.avatar) : NetworkImage(''),
                                  child: contact.avatar.isEmpty ? Text(contact.displayName[0]) : Text(''),
                                  radius: 20.0,
                                ),
                              )
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ));
  }

  bool contactIsSelected(Contact contact) {
    return selectedContacts.any((Contact selectedContact) => selectedContact.displayName == contact.displayName);
  }

  bool needSelectMultipleContacts() {
    return widget.chatGroupType == ChatGroupType.Group || widget.chatGroupType == ChatGroupType.Broadcast;
  }

  // TODO: Conversation Creation into BLOC, can be merged with Group & Broadcast
  Future<Conversation> createPersonalConversation(Contact contact) async {
    Conversation conversation = new Conversation();
    int newId = generateNewId();
    conversation.id = newId.toString();
    conversation.name = contact.displayName;

    // convert contact to contact (self defined)
    List<UserContact> userContacts = [];

    //Determine how many phone number he has
    List<String> primaryNo = [];
    if (contact.phones.length > 0) {
      contact.phones.forEach((phoneNo) {
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

    conversation.type = ChatGroupType.Personal;
    conversation.contacts = userContacts;
    conversation.block = false;
    conversation.description = '';
    conversation.groupPhoto = Multimedia(imageData: null, localUrl: null, remoteUrl: null, thumbnail: null);
    conversation.unreadMessage = UnreadMessage(count: 0, date: 0, lastMessage: "");
    conversation.groupPhoto = Multimedia(remoteUrl: "", localUrl: '', imageData: contact.avatar, imageFile: null, thumbnail: "");

    return conversation;
  }

  int generateNewId() {
    var random = new Random();
    // Formula: random.nextInt((max - min) + 1) + min;
    int newId = random.nextInt((999999999 - 100000000) + 1) + 100000000;
    return newId;
  }
}
