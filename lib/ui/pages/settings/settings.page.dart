import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  SettingsBloc settingsBloc;
  UserBloc userBloc;
  UserContactBloc userContactBloc;

  RefreshController _refreshController;

  List<IconData> settingsIcons = [Icons.account_circle, Icons.format_paint, Icons.chat, Icons.notifications, Icons.lock, Icons.security];
  List<String> settingsButtons = ['Account', 'Theme', 'Chat', 'Notifications', 'Privacy', 'Security'];
  List<ListTile> allSettings = [];

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    settingsBloc = BlocProvider.of<SettingsBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);
    userContactBloc = BlocProvider.of<UserContactBloc>(context);

    initializeSettingsButtons();

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: onRefresh,
        enablePullDown: true,
        physics: BouncingScrollPhysics(),
        header: ClassicHeader(),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: allSettings.length,
            itemBuilder: (context, index) {
              return allSettings[index];
            }),
      ),
    );
  }

  initializeSettingsButtons() {
    for (int i = 0; i < settingsButtons.length; i++) {
      allSettings.add(ListTile(
          title: Text(settingsButtons[i]),
          leading: Icon(settingsIcons[i]),
          // Change phone number, Change picture, Change cover photo, change username, change Bio, change display name
          onTap: () {}));
    }
  }

  onRefresh() {
    userBloc.add(GetOwnUserEvent(callback: (User user) {}));
    settingsBloc.add(GetUserOwnSettingsEvent(callback: (Settings settings) {}));
    userContactBloc.add(GetUserOwnUserContactEvent(callback: (bool done) {
      if (done) {
        userContactBloc.add(GetUserOwnUserContactsEvent(callback: (bool done) {}));
      }
    }));
    setState(() {
      _refreshController.refreshCompleted();
    });
  }
}
