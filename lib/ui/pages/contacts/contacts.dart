import 'dart:async';

import 'package:flutter/material.dart';

// Import package
import 'package:contacts_service/contacts_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';

class ContactsPage extends StatefulWidget {
  final List<Contact> contactList;
  final Map<String, bool> contactCheckBoxes;
  final ChatGroupType chatGroupType;

  ContactsPage({this.chatGroupType, this.contactList, this.contactCheckBoxes});

  @override
  State<StatefulWidget> createState() {
    return new ContactsPageState();
  }
}

class ContactsPageState extends State<ContactsPage> {
  bool isLoading = true;
  PermissionStatus permissionStatus;
  List<Contact> selectedContacts = [];
  String title = "";
  RefreshController _refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = new RefreshController();
  }

  @override
  Widget build(BuildContext context) {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
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
            Expanded(
              child: Container(
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Icon(Icons.check),
                  onTap: () {
                    print("Next Page!");
                  },
                ),
              )
            ),
          ],
        )),
        body: SmartRefresher(
          enablePullDown: false,
          child: ListView(
            children: widget.contactList.map((contact) {
              return CheckboxListTile(
                title: Text(contact.displayName),
                subtitle: Text('Hey There! I am using PocketChat.'),
                value: widget.contactCheckBoxes[contact.displayName],
                onChanged: (bool value) {
                  setState(() {
                    widget.contactCheckBoxes[contact.displayName] = value;
                  });
                },
              );
            }).toList(),
          ),
        ));
  }
}
