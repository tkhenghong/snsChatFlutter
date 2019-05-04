import 'dart:async';

import 'package:flutter/material.dart';

// Import package
import 'package:contacts_service/contacts_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/ui/pages/group_name/group_name_page.dart';

class SelectContactsPage extends StatefulWidget {
  final List<Contact> contactList;
  final Map<String, bool> contactCheckBoxes;
  final ChatGroupType chatGroupType;

  SelectContactsPage({this.chatGroupType, this.contactList, this.contactCheckBoxes});

  @override
  State<StatefulWidget> createState() {
    return new SelectContactsPageState();
  }
}

class SelectContactsPageState extends State<SelectContactsPage> {
  bool isLoading = true;
  PermissionStatus permissionStatus;
  List<Contact> selectedContacts = [];
  String title = "";
  RefreshController _refreshController;

  @override
  initState() {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => GroupNamePage(
                              selectedContacts: selectedContacts))));
                },
              ),
            ),
          ],
        )),
        body: SmartRefresher(
          enablePullDown: false,
          controller: _refreshController,
          child: ListView(
            children: widget.contactList.map((Contact contact) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text(
                        contact.displayName,
                        softWrap: true,
                      ),
                      subtitle: Text(
                        'Hey There! I am using PocketChat.',
                        softWrap: true,
                      ),
                      value: widget.contactCheckBoxes[contact.displayName],
                      onChanged: (bool value) {
                        if (contactIsSelected(contact)) {
                          print("if (contactIsSelected(contact))");
                          selectedContacts.remove(contact);
                        } else {
                          print("if (!contactIsSelected(contact))");
                          selectedContacts.add(contact);
                        }
                        print("Current list of selected contacts: ");
                        selectedContacts.forEach((contact) => print(
                            "contact.displayName: " + contact.displayName));
                        print("for loop end.");
                        setState(() {
                          widget.contactCheckBoxes[contact.displayName] = value;
                        });
                      },
                      secondary: CircleAvatar(
                        backgroundImage: MemoryImage(contact.avatar),
                        child: contact.avatar == null ? Text(contact.displayName[0]): null,
                        radius: 20.0,
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ));
  }

  bool contactIsSelected(Contact contact) {
    return selectedContacts.any((Contact selectedContact) =>
        selectedContact.displayName == contact.displayName);
  }
}
