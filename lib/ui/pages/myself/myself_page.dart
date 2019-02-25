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
        name: "Settings",
        icon: Icon(Icons.settings),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        name: "About",
        icon: Icon(Icons.info),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        name: "Help",
        icon: Icon(Icons.help),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        name: "Feedback",
        icon: Icon(Icons.feedback),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
    PageListItem(
        name: "Logout",
        icon: Icon(Icons.exit_to_app),
        onTap: (context) => Navigator.pushNamed(context, "settings_page")),
  ];
}
