import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';

class MyselfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyselfPageState();
  }
}

class MyselfPageState extends State<MyselfPage> {
  static WholeAppBloc wholeAppBloc;

  @override
  Widget build(BuildContext context) {
    final WholeAppBloc _wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
    wholeAppBloc = _wholeAppBloc;

    return new PageListView(array: listItems, context: context);
  }

  List<PageListItem> listItems = [
    PageListItem(
        title: Text("Settings"),
        leading: Icon(Icons.settings),
        onTap: (context, object) => goToSettingsPage(context, object)),
    PageListItem(
        title: Text("About"),
        leading: Icon(Icons.info),
        onTap: (context, object) => goToSettingsPage(context, object)),
    PageListItem(
        title: Text("Help"),
        leading: Icon(Icons.help),
        onTap: (context, object) => goToSettingsPage(context, object)),
    PageListItem(
        title: Text("Feedback"),
        leading: Icon(Icons.feedback),
        onTap: (context, object) => goToSettingsPage(context, object)),
    PageListItem(
        title: Text("Logout"),
        leading: Icon(Icons.exit_to_app),
        onTap: (context, object) {
          logOut(context, object);
        }),
  ];

  static goToSettingsPage(BuildContext context, object) {
    return Navigator.of(context).pushNamed("settings_page");
  }

  static logOut(BuildContext context, object) {
    wholeAppBloc.dispatch(UserSignOutEvent());
    return Navigator.of(context).pushReplacementNamed("login_page");
  }
}
