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
        title: new Text("Settings"),
        leading: new Icon(Icons.settings),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: new Text("About"),
        leading: new Icon(Icons.info),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: new Text("Help"),
        leading: new Icon(Icons.help),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: new Text("Feedback"),
        leading: new Icon(Icons.feedback),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        title: new Text("Logout"),
        leading: new Icon(Icons.exit_to_app),
        onTap: (context) => Navigator.pushReplacementNamed(context, "login_page")),
  ];
}
