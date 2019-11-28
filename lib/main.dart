import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/database/startup.dart';
import 'package:snschat_flutter/objects/index.dart';

import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

import 'package:snschat_flutter/ui/pages/chats/chat_group_list/chat_group_list_page.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_info/chat_info_page.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room_page.dart';
import 'package:snschat_flutter/ui/pages/select_contacts/select_contacts_page.dart';
import 'package:snschat_flutter/ui/pages/login/login_page.dart';
import 'package:snschat_flutter/ui/pages/myself/myself_page.dart';
import 'package:snschat_flutter/ui/pages/privacy_notice/privacy_notice_page.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code_page.dart';
import 'package:snschat_flutter/ui/pages/settings/settings_page.dart';
import 'package:snschat_flutter/ui/pages/sign_up/sign_up_page.dart';
import 'package:snschat_flutter/ui/pages/tabs/tabs_page.dart';
import 'package:snschat_flutter/ui/pages/terms_and_conditions/terms_and_conditions_page.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number_page.dart';

import 'database/sembast/SembastDB.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ConversationGroupBloc>(
      builder: (context) {
        return ConversationGroupBloc()..add(InitializeConversationGroupsEvent(callback: (bool done) {}));
      },
    ),
    BlocProvider<GoogleInfoBloc>(
      builder: (context) {
        return GoogleInfoBloc()..add(InitializeGoogleInfoEvent(callback: (bool done) {}));
      },
    ),
    BlocProvider<IPGeoLocationBloc>(
      builder: (context) {
        return IPGeoLocationBloc()..add(GetIPGeoLocationEvent(callback: (IPGeoLocation ipGeoLocation) {}));
      },
    ),
    BlocProvider<MessageBloc>(
      builder: (context) {
        return MessageBloc()..add(InitializeMessagesEvent(callback: (bool done) {}));
      },
    ),
    BlocProvider<MultimediaBloc>(
      builder: (context) {
        return MultimediaBloc()..add(InitializeMultimediaEvent(callback: (bool done) {}));
      },
    ),
    BlocProvider<SettingsBloc>(
      builder: (context) {
        return SettingsBloc()..add(InitializeSettingsEvent(callback: (bool done) {}));
      },
    ),
    BlocProvider<UnreadMessageBloc>(
      builder: (context) {
        return UnreadMessageBloc()..add(InitializeUnreadMessagesEvent(callback: (bool done) {}));
      },
    ),
    BlocProvider<UserBloc>(
      builder: (context) {
        return UserBloc()..add(InitializeUserEvent(callback: (bool done) {}));
      },
    ),
    BlocProvider<UserContactBloc>(
      builder: (context) {
        return UserContactBloc()..add(InitializeUserContactsEvent(callback: (bool done) {}));
      },
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.black;
    Color primaryColorInText = Colors.white;
    Color primaryColorWhenFocus = Colors.black54;
    Brightness primaryBrightness = Brightness.light;
    TextStyle primaryTextStyle = TextStyle(color: primaryColor);
    TextStyle primaryTextStyleInAppBarText = TextStyle(color: primaryColorInText, fontSize: 18.0, fontWeight: FontWeight.bold);

    return MaterialApp(
      title: 'PocketChat',
      theme: ThemeData(
//        fontFamily: 'OpenSans',
        brightness: primaryBrightness,
        primaryColor: primaryColor,
        accentColor: primaryColor,
        cursorColor: primaryColor,
        highlightColor: primaryColorWhenFocus,
        textSelectionColor: primaryColorWhenFocus,
        buttonColor: primaryColor,
        buttonTheme: ButtonThemeData(buttonColor: primaryColor, textTheme: ButtonTextTheme.primary),
        errorColor: primaryColor,
        bottomAppBarColor: primaryColor,
        bottomAppBarTheme: BottomAppBarTheme(
          color: primaryColor,
        ),
        appBarTheme: AppBarTheme(
            color: primaryColor,
            textTheme: TextTheme(
              button: primaryTextStyleInAppBarText,
              title: primaryTextStyleInAppBarText,
            )),
      ),
      home: TabsPage(),
      routes: {
        "login_page": (_) => new LoginPage(),
        "privacy_notice_page": (_) => new PrivacyNoticePage(),
        "sign_up_page": (_) => new SignUpPage(),
        "terms_and_conditions_page": (_) => TermsAndConditionsPage(),
        "verify_phone_number_page": (_) => VerifyPhoneNumberPage(),
        "tabs_page": (_) => TabsPage(),
        "chat_group_list_page": (_) => new ChatGroupListPage(),
        "scan_qr_code_page": (_) => new ScanQrCodePage(),
        "settings_page": (_) => new SettingsPage(),
        "myself_page": (_) => new MyselfPage(),
        "chat_room_page": (_) => new ChatRoomPage(),
        "chat_info_page": (_) => new ChatInfoPage(),
        "contacts_page": (_) => new SelectContactsPage(),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
