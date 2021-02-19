import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';

class MyselfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyselfPageState();
  }
}

class MyselfPageState extends State<MyselfPage> {
  EnvironmentGlobalVariables env = Get.find();

  RefreshController _refreshController;

  static IPGeoLocationBloc ipGeoLocationBloc;
  static AuthenticationBloc authenticationBloc;
  static MultimediaProgressBloc multimediaProgressBloc;
  static ConversationGroupBloc conversationGroupBloc;
  static ChatMessageBloc messageBloc;
  static MultimediaBloc multimediaBloc;
  static UnreadMessageBloc unreadMessageBloc;
  static UserContactBloc userContactBloc;
  static SettingsBloc settingsBloc;
  static UserBloc userBloc;
  static WebSocketBloc webSocketBloc;

  User ownUser = User(mobileNo: '', realName: '', displayName: '', countryCode: '');
  UserContact ownUserContact;
  Multimedia userOwnMultimedia;

  List<ListTile> buttons;
  int settingListOriginalLength = 0;

  bool firstTime = true;

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    loadButtons();
  }

  loadButtons() {
    buttons = [
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

    settingListOriginalLength = buttons.length;
  }

  @override
  Widget build(BuildContext context) {
    ipGeoLocationBloc = BlocProvider.of<IPGeoLocationBloc>(context);
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    multimediaProgressBloc = BlocProvider.of<MultimediaProgressBloc>(context);
    conversationGroupBloc = BlocProvider.of<ConversationGroupBloc>(context);
    messageBloc = BlocProvider.of<ChatMessageBloc>(context);
    multimediaBloc = BlocProvider.of<MultimediaBloc>(context);
    unreadMessageBloc = BlocProvider.of<UnreadMessageBloc>(context);
    userContactBloc = BlocProvider.of<UserContactBloc>(context);
    settingsBloc = BlocProvider.of<SettingsBloc>(context);
    userBloc = BlocProvider.of<UserBloc>(context);
    webSocketBloc = BlocProvider.of<WebSocketBloc>(context);

    if (firstTime) {
      initialize();
      firstTime = false;
    }

    return SafeArea(child: userBlocBuilder());
  }

  Widget userBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          ownUser = userState.user;
          if (!isObjectEmpty(ownUser)) {
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
          ownUserContact = userContactState.ownUserContact;
          if (!isObjectEmpty(ownUserContact)) {
            return multimediaBlocBuilder();
          }
        }
        return showErrorPage('Error. Unable to load user info. Please sign in again.');
      },
    );
  }

  Widget multimediaBlocBuilder() {
    return BlocBuilder<MultimediaBloc, MultimediaState>(
      builder: (context, multimediaState) {
        if (multimediaState is MultimediaLoaded) {
          List<Multimedia> multimediaList = multimediaState.multimediaList;
          userOwnMultimedia = multimediaList.firstWhere((Multimedia existingMultimedia) => ownUserContact.profilePicture == existingMultimedia.id, orElse: () => null);
          insertUserProfilePicture();
          return mainBody();
        }
        return showErrorPage('Error. Multimedia not loaded. Please sign in again.');
      },
    );
  }

  Widget mainBody() {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: refreshUserData,
      child: ListView.builder(
          itemCount: buttons.length,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          // suggestion from https://github.com/flutter/flutter/issues/22314
          itemBuilder: (BuildContext content, int index) {
            return buttons[index];
          }),
    );
  }

  insertUserProfilePicture() {
    Widget defaultImage = CircleAvatar(backgroundImage: AssetImage(DefaultImagePathType.UserContact.path));

    ListTile listTile = ListTile(
      title: Text(ownUser.displayName),
      subtitle: Text(!isObjectEmpty(ownUserContact.about) ? ownUserContact.about : 'Write about yourself...'),
      leading: Hero(
        tag: ownUser.id + "1",
        child: CachedNetworkImage(
          imageUrl: '${env.REST_URL}/userContact/profilePicture',
          // Get own profile Picture
          useOldImageOnUrlChange: true,
          placeholder: (context, url) => defaultImage,
          errorWidget: (context, url, error) => defaultImage,
          imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
            return CircleAvatar(
              backgroundImage: imageProvider,
            );
          },
        ),
      ),
      onTap: onUserProfilePictureTapped,
    );

    if (buttons.length + 1 > settingListOriginalLength) {
      // Remove previous UserProfilePicture.
      buttons.removeAt(0);
    }
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

  initialize() {
    refreshUserData();
  }

  refreshUserData() {
    userBloc.add(GetOwnUserEvent(callback: (User user) {}));
    userContactBloc.add(GetUserOwnUserContactEvent(callback: (UserContact userContact) {}));
    multimediaBloc.add(GetUserOwnProfilePictureMultimediaEvent(callback: (bool done) {}));
    settingsBloc.add(GetUserOwnSettingsEvent(callback: (Settings settings) {}));
  }

  onUserProfilePictureTapped() {
    showToast('Coming soon on change user\'s description.', Toast.LENGTH_SHORT);
  }

  goToSettingsPage() {
    Navigator.of(context).pushNamed("settings_page");
  }

  logOut() {
    ipGeoLocationBloc.add(InitializeIPGeoLocationEvent(callback: (bool done) {}));
    conversationGroupBloc.add(RemoveConversationGroupsEvent(callback: (bool done) {}));
    messageBloc.add(RemoveAllChatMessagesEvent(callback: (bool done) {}));
    multimediaBloc.add(RemoveAllMultimediaEvent(callback: (bool done) {}));
    multimediaProgressBloc.add(RemoveAllMultimediaProgressEvent(callback: (bool done) {}));
    settingsBloc.add(RemoveAllSettingsEvent(callback: (bool done) {}));
    unreadMessageBloc.add(RemoveAllUnreadMessagesEvent(callback: (bool done) {}));
    userBloc.add(RemoveAllUsersEvent(callback: (bool done) {}));
    userContactBloc.add(RemoveAllUserContactsEvent(callback: (bool done) {}));
    authenticationBloc.add(RemoveAllAuthenticationsEvent(callback: (bool done) {}));

    Navigator.of(context).pushNamedAndRemoveUntil('login_page', (Route<dynamic> route) => false);
  }
}
