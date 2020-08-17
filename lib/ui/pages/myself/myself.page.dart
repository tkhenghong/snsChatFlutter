import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

class MyselfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyselfPageState();
  }
}

class MyselfPageState extends State<MyselfPage> {
  static IPGeoLocationBloc ipGeoLocationBloc;
  static GoogleInfoBloc googleInfoBloc;

  static NavigatorState navigatorState;

  User user = User(mobileNo: '', realName: '', displayName: '', countryCode: '', googleAccountId: '');
  UserContact userContact;
  Multimedia multimedia;

  List<ListTile> buttons = [
    ListTile(
        title: Text("Settings"),
        leading: Icon(Icons.settings),
        onTap: () {
          goToSettingsPage();
        }),
    ListTile(
        title: Text("About"),
        leading: Icon(Icons.info),
        onTap: () {
          goToSettingsPage();
        }),
    ListTile(
        title: Text("Help"),
        leading: Icon(Icons.help),
        onTap: () {
          goToSettingsPage();
        }),
    ListTile(
        title: Text("Feedback"),
        leading: Icon(Icons.feedback),
        onTap: () {
          goToSettingsPage();
        }),
    ListTile(
        title: Text("Logout"),
        leading: Icon(Icons.exit_to_app),
        onTap: () {
          logOut();
        }),
  ];

  ImageService imageService = Get.find();

  @override
  Widget build(BuildContext context) {
    ipGeoLocationBloc = BlocProvider.of<IPGeoLocationBloc>(context);
    googleInfoBloc = BlocProvider.of<GoogleInfoBloc>(context);
    navigatorState = Navigator.of(context);

    return Material(child: userBlocBuilder());
  }

  Widget userBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          user = userState.user;
          if (!isObjectEmpty(user)) {
            return userContactBlocBuilder();
          }
        }
        return showErrorPage('Error. User not loaded. Please sign in again.');
      },
    );
  }

  Widget userContactBlocBuilder() {
    return BlocBuilder<UserContactBloc, UserContactState>(
      builder: (context, userContactState) {
        if (userContactState is UserContactsLoaded) {
          List<UserContact> userContactList = userContactState.userContactList;

          userContact = userContactList.firstWhere((UserContact existingUserContact) => user.id == existingUserContact.userId.toString(), orElse: () => null);
          if (!isObjectEmpty(userContact)) {
            return multimediaBlocBuilder();
          }
        }
        return showErrorPage('Error. Unable to load user. Please sign in again.');
      },
    );
  }

  Widget multimediaBlocBuilder() {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        if (multimediaState is MultimediaLoaded) {
          List<Multimedia> multimediaList = multimediaState.multimediaList;
          multimedia = multimediaList.firstWhere((Multimedia existingMultimedia) => user.id == existingMultimedia.userId, orElse: null);
          if (!isObjectEmpty(multimedia)) {
            return showMyselfPage();
          }
        }
        return showErrorPage('Error. Multimedia not loaded. Please sign in again.');
      },
    );
  }

//  Widget showMyselfPage() {
//    insertUserProfilePicture();
//    return Column(
//      children: <Widget>[PageListView(array: buttons, context: context)],
//    );
//  }

  Widget showMyselfPage() {
    insertUserProfilePicture();
    return Column(
      children: <Widget>[
        ListView.builder(
            itemCount: buttons.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            // suggestion from https://github.com/flutter/flutter/issues/22314
            itemBuilder: (BuildContext content, int index) {
              return buttons[index];
            })
      ],
    );
  }

  insertUserProfilePicture() {
    ListTile listTile = ListTile(
      title: Text(user.displayName),
      subtitle: Text(!isStringEmpty(userContact.about) ? userContact.about : ''),
      leading: Hero(
        tag: user.id + "1",
        child: imageService.loadImageThumbnailCircleAvatar(multimedia, DefaultImagePathType.Profile),
      ),
    );
    buttons.insert(0, listTile);
  }

  Widget showErrorPage(String message) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: Get.height * 0.35)),
        Center(
          child: Text(message),
        ),
        RaisedButton(
          child: Text('Go to Sign In'),
          onPressed: () {
            logOut();
          },
        ),
      ],
    );
  }

  static goToSettingsPage() {
    navigatorState.pushNamed("settings_page");
  }

  static logOut() {
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (IPGeoLocation ipGeoLocation) {}));
    googleInfoBloc.add(RemoveGoogleInfoEvent(callback: (bool done) {}));
    navigatorState.pushReplacementNamed("login_page");
  }
}
