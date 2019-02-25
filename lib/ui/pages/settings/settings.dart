import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return new Material(
        color: Colors.white, child: buildListElementLayout(context));
  }

  Widget buildListElementLayout(BuildContext context) {
    return new PageListView(array: allSettings, context: context);
  }

  List<PageListItem> allSettings = [
    PageListItem(
        name: "Account",
        icon: Icon(Icons.account_circle),
        // Change phone number, Change picture, Change cover photo, change username, change Bio, change display name
        onTap: (context) => print('Executed route')),
    PageListItem(
        name: "Theme",
        icon: Icon(Icons.format_paint),
        // Message text size, text font family, Auto-Night mode, Color theme (Telegram)
        onTap: (context) => print('Executed route')),
    PageListItem(
        name: "Chat",
        icon: Icon(Icons.chat),
        // Link open externally, Chat Animations, Save to Gallery, Send by Enter, Stickers Management, Chat Backup (Cloud/Local)
        onTap: (context) => print('Executed route')),
    PageListItem(
        name: "Notifications",
        icon: Icon(Icons.notifications),
        // Notification ringtone, Vibrate type, Badge counter, In-app sounds, In-app vibrate, In-app Preview, In-chat sounds, Joined Telegram, Created Pinned Message, Background Connection
        onTap: (context) => print('Executed route')),
    PageListItem(
        name: "Privacy",
        icon: Icon(Icons.lock),
        // Friend confirmation, Find Contact in storage, Blocked list, Methods of Adding me, Sync Contacts, Suggest Frequent Contacts
        onTap: (context) => print('Executed route')),
    PageListItem(
        name: "Security",
        icon: Icon(Icons.security),
        onTap: (context) => print('Executed route')),
  ];
}
