import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';

class MyselfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyselfPageState();
  }
}

class MyselfPageState extends State<MyselfPage> {
  @override
  Widget build(BuildContext context) {
    return new PageListView(array: listItems, context: context);
  }

  List<PageListItem> listItems = [
    PageListItem(
        title: Text("Settings"),
        leading: Icon(Icons.settings),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: Text("About"),
        leading: Icon(Icons.info),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: Text("Help"),
        leading: Icon(Icons.help),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: Text("Feedback"),
        leading: Icon(Icons.feedback),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: Text("Logout"),
        leading: Icon(Icons.exit_to_app),
        onTap: (context) =>
            Navigator.pushReplacementNamed(context, "login_page")),
  ];
}
