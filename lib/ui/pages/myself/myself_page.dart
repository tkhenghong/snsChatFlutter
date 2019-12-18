import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/general/ui-component/list-view.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

class MyselfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyselfPageState();
  }
}

class MyselfPageState extends State<MyselfPage> {
  @override
  Widget build(BuildContext context2) {
    print('myself_page.dart build()');

    List<PageListItem> listItems = [
      PageListItem(title: Text("Settings"), leading: Icon(Icons.settings), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(title: Text("About"), leading: Icon(Icons.info), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(title: Text("Help"), leading: Icon(Icons.help), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(title: Text("Feedback"), leading: Icon(Icons.feedback), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(
          title: Text("Logout"),
          leading: Icon(Icons.exit_to_app),
          onTap: (context, object) {
            BlocProvider.of<IPGeoLocationBloc>(context2).add(InitializeIPGeoLocationEvent(callback: (IPGeoLocation ipGeoLocation) {}));
            BlocProvider.of<GoogleInfoBloc>(context2).add(RemoveGoogleInfoEvent(callback: (bool done) {}));
            logOut(context2);
          }),
    ];

    return PageListView(array: listItems, context: context);
  }



  static goToSettingsPage(BuildContext context) {
    return Navigator.of(context).pushNamed("settings_page");
  }

  static logOut(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed("login_page");
  }
}
