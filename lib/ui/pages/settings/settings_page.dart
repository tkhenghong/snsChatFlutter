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
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.black,
      ),
      body: PageListView(array: allSettings, context: context),
    );
  }

  List<PageListItem> allSettings = [
    PageListItem(
        title: Text("Account"),
        leading: Icon(Icons.account_circle),
        // Change phone number, Change picture, Change cover photo, change username, change Bio, change display name
        onTap: (context) => print('Executed route')),
    PageListItem(
        title: Text("Theme"),
        leading: Icon(Icons.format_paint),
        // Message text size, text font family, Auto-Night mode, Color theme (Telegram)
        onTap: (context) => print('Executed route')),
    PageListItem(
        title: Text("Chat"),
        leading: Icon(Icons.chat),
        // Link open externally, Chat Animations, Save to Gallery, Send by Enter, Stickers Management, Chat Backup (Cloud/Local)
        onTap: (context) => print('Executed route')),
    PageListItem(
        title: Text("Notifications"),
        leading: Icon(Icons.notifications),
        // Notification ringtone, Vibrate type, Badge counter, In-app sounds, In-app vibrate, In-app Preview, In-chat sounds, Joined Telegram, Created Pinned Message, Background Connection
        onTap: (context) => print('Executed route')),
    PageListItem(
        title: Text("Privacy"),
        leading: Icon(Icons.lock),
        // Friend confirmation, Find Contact in storage, Blocked list, Methods of Adding me, Sync Contacts, Suggest Frequent Contacts
        onTap: (context) => print('Executed route')),
    PageListItem(
        title: Text("Security"),
        leading: Icon(Icons.security),
        onTap: (context) => print('Executed route')),
  ];
}
