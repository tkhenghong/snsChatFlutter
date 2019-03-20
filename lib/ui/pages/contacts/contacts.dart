import 'dart:async';

import 'package:flutter/material.dart';

// Import package
import 'package:contacts_service/contacts_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ContactsPageState();
  }
}

class ContactsPageState extends State<ContactsPage> {
  bool isLoading = true;
  PermissionStatus permissionStatus;
  List<Contact> selectedContacts = [];
  Map<String, bool> contactCheckBoxes = {};
  RefreshController _refreshController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = new RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    print('build()');
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Group Chat",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "Select a contact",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
      body: FutureBuilder(
          future: getContacts(context),
          builder:
              (BuildContext context, AsyncSnapshot<PageListView> feedState) {
            print(
                ' builder: (BuildContext context, AsyncSnapshot<PageListView> feedState)');
            if (feedState.error != null) {
              print('if (feedState.error != null)');
              // TODO: error handling
            }
            if (feedState.data == null) {
              print('if (feedState.data == null)');
              return new Center(child: new CircularProgressIndicator());
            }
            print('return feedState.data;');
            return feedState.data;
          }),
    );
  }

//  getPermission() {
//    SimplePermissions.requestPermission(Permission.ReadContacts).then((status) {
//      return status;
//    });
//  }

  Future<PageListView> getContacts(BuildContext context) async {
    // TODO: Handle when user denies permission
//    permissionStatus =
//        await SimplePermissions.requestPermission(Permission.ReadContacts);
    print('getContacts()');
    // Get all contacts on device
    Iterable<Contact> contacts = await ContactsService.getContacts();
    print("Got here?");
    List<Contact> contactList = contacts.toList(growable: true);
    print("contactList: " + contactList.toString());
    contactList.forEach((contact) {
      print(contact.displayName);
      print(
          "contact.avatar.isNotEmpty: " + contact.avatar.isNotEmpty.toString());

      // Create checkbox for the element
      contactCheckBoxes[contact.displayName] = false;
      PageListItem newPLI = PageListItem(
          object: contact,
          title: Text(contact.displayName),
          subtitle: Text('Hey There! I am using PocketChat.'),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: contact.avatar.isNotEmpty
                ? MemoryImage(contact.avatar)
                : AssetImage('lib/ui/icons/default_user_icon.png'),
          ),
          onTap: (context, Contact contact) {
            print("Clicked!");
            print("contact.displayName: " + contact.displayName);
            if (selectedContacts.contains(contact)) {
              print('if(selectedContacts.contains(contact))');
              selectedContacts.remove(contact);
              contactCheckBoxes[contact.displayName] = false;
            } else {
              print('if(!selectedContacts.contains(contact))');
              selectedContacts.add(contact);
              contactCheckBoxes[contact.displayName] = true;
            }
            print('check contactCheckBoxes[contact.displayName]: ' + contactCheckBoxes[contact.displayName].toString());
            print('Current list contains: ');
            selectedContacts.forEach((Contact contact) {
              print('contact.displayName: ' + contact.displayName);
            });
          },
          trailing: Checkbox(
              value: contactCheckBoxes[contact.displayName],
              onChanged: (bool value) {
                print('Checkbox onChanged()');
                print('Checkbox value: ' + value.toString());
                setState(() {
                  print('setState()');
                contactCheckBoxes[contact.displayName] = value;
                });
              }
              ));

      if (!pageListItems.any((item) {
        return (item.object as Contact).displayName ==  (newPLI.object as Contact).displayName;
      })) {
        print('!pageListItems.any((item)');
        pageListItems.add(newPLI);
      }

      List<Item> phoneList = contact.phones.toList();
      phoneList.forEach((phoneNo) {
        print(phoneNo.label);
        print(phoneNo.value);
      });
    });
    print('pageListItems.length: ' + pageListItems.length.toString());
    print("contactCheckBoxes.length: " + contactCheckBoxes.length.toString());
    return Future.value(
//        ListView(
//          children: contactCheckBoxes.keys.map((String key) {
//            return CheckboxListTile(
//              title: Text(key),
//              value: contactCheckBoxes[key],
//              onChanged: (bool value) {
//                setState(() {
//                  contactCheckBoxes[key] = value;
//                });
//              },
//            );
//          }).toList(),
//        )

        PageListView(array: pageListItems, context: context)

//        new SmartRefresher(
//          enablePullUp: false,
//          enablePullDown: false,
//          controller: _refreshController,
//          onRefresh: (up) {
//            if (up) {
//              Future.delayed(Duration(seconds: 1), () {
//                //Delay 1 second to simulate something loading
//                _refreshController.sendBack(up, RefreshStatus.completed);
//              });
//            }
//          },
//            child: new ListView.builder(
//                itemCount: pageListItems.length,
//                physics: const AlwaysScrollableScrollPhysics(),
//                //suggestion from https://github.com/flutter/flutter/issues/22314
//                itemBuilder: (BuildContext content, int index) {
//                  PageListItem listItem = pageListItems[index];
//                  return new CheckBoxListTile(listItem, context, contactCheckBoxes);
//                })
//        )

        );
  }

  List<PageListItem> pageListItems = [];
}
