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
  double deviceWidth;
  double deviceHeight;

  Color appBarThemeTextColor;
  Color themePrimaryColor;

  User blankUser = User(mobileNo: '', realName: '', displayName: '', countryCode: '', googleAccountId: '');

  ImageService imageService = Get.find();

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    themePrimaryColor = Theme.of(context).textTheme.title.color;
    appBarThemeTextColor = Theme.of(context).appBarTheme.textTheme.title.color;

    List<PageListItem> listItems = [
      PageListItem(title: Text("Settings"), leading: Icon(Icons.settings), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(title: Text("About"), leading: Icon(Icons.info), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(title: Text("Help"), leading: Icon(Icons.help), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(title: Text("Feedback"), leading: Icon(Icons.feedback), onTap: (context, object) => goToSettingsPage(context)),
      PageListItem(
          title: Text("Logout"),
          leading: Icon(Icons.exit_to_app),
          onTap: (context, object) {
            logOut(context);
          }),
    ];

    return Material(
      color: appBarThemeTextColor,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is UserLoaded) {
            User user = userState.user;

            return BlocBuilder<UserContactBloc, UserContactState>(
              builder: (context, userContactState) {
                if (userContactState is UserContactsLoaded) {
                  List<UserContact> userContactList = userContactState.userContactList;

                  UserContact userContact = userContactList.firstWhere((UserContact existingUserContact) => user.id == existingUserContact.userId.toString(), orElse: () => null);
                  if (!isObjectEmpty(userContact)) {
                    return BlocBuilder<MultimediaBloc, MultimediaState>(
                      builder: (context, multimediaState) {
                        if (multimediaState is MultimediaLoaded) {
                          List<Multimedia> multimediaList = multimediaState.multimediaList;
                          Multimedia multimedia = multimediaList.firstWhere((Multimedia existingMultimedia) => user.id == existingMultimedia.userId, orElse: null);
                          if (!isObjectEmpty(multimedia)) {
                            return showMyselfPage(context, user, userContact, multimedia, listItems);
                          }
                        }
                        return showErrorPage(context, 'Error. Multimedia not loaded. Please sign in again.');
                      },
                    );
                  }
                }
                return showErrorPage(context, 'Error. Unable to load user. Please sign in again.');
              },
            );
          }
          return showErrorPage(context, 'Error. User not loaded. Please sign in again.');
        },
      ),
    );
  }

  Widget showMyselfPage(BuildContext context, User user, UserContact userContact, Multimedia multimedia, List<PageListItem> listItems) {
    PageListItem pageListItem = PageListItem(
      title: Text(user.displayName),
      subtitle: Text(!isStringEmpty(userContact.about) ? userContact.about : ''),
      leading: Hero(
        tag: user.id + "1",
        child: imageService.loadImageThumbnailCircleAvatar(multimedia, DefaultImagePathType.Profile, context),
      ),
    );
    listItems.insert(0, pageListItem);
    return Column(
      children: <Widget>[PageListView(array: listItems, context: context)],
    );
  }

  Widget showErrorPage(BuildContext context, String message) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: deviceHeight * 0.35)),
        Center(
          child: Text(message),
        ),
        RaisedButton(
          child: Text('Go to Sign In'),
          onPressed: () => logOut(context),
          textColor: appBarThemeTextColor,
        ),
      ],
    );
  }

  static goToSettingsPage(BuildContext context) {
    return Navigator.of(context).pushNamed("settings_page");
  }

  static logOut(BuildContext context) {
    BlocProvider.of<IPGeoLocationBloc>(context).add(InitializeIPGeoLocationEvent(callback: (IPGeoLocation ipGeoLocation) {}));
    BlocProvider.of<GoogleInfoBloc>(context).add(RemoveGoogleInfoEvent(callback: (bool done) {}));
    return Navigator.of(context).pushReplacementNamed("login_page");
  }
}
