import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_group_list/chat_group_list.page.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_info/chat_info.page.dart';
import 'package:snschat_flutter/ui/pages/chats/chat_room/chat_room.page.dart';
import 'package:snschat_flutter/ui/pages/login/login.page.dart';
import 'package:snschat_flutter/ui/pages/myself/myself.page.dart';
import 'package:snschat_flutter/ui/pages/photo_view/photo_view.page.dart';
import 'package:snschat_flutter/ui/pages/privacy_notice/privacy_notice.page.dart';
import 'package:snschat_flutter/ui/pages/scan_qr_code/scan_qr_code.page.dart';
import 'package:snschat_flutter/ui/pages/select_contacts/select_contacts.page.dart';
import 'package:snschat_flutter/ui/pages/settings/settings.page.dart';
import 'package:snschat_flutter/ui/pages/sign_up/sign_up.page.dart';
import 'package:snschat_flutter/ui/pages/tabs/tabs.page.dart';
import 'package:snschat_flutter/ui/pages/terms_and_conditions/terms_and_conditions.page.dart';
import 'package:snschat_flutter/ui/pages/verify_phone_number/verify_phone_number.page.dart';
import 'package:snschat_flutter/ui/pages/video_player/video_player.page.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize().then((data) {
//    print('FlutterDownloader.initialize() completed');
//    print('data: ' + data.toString());
  });

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<ConversationGroupBloc>(
      create: (context) => ConversationGroupBloc(),
    ),
    BlocProvider<GoogleInfoBloc>(
      create: (context) => GoogleInfoBloc(),
    ),
    BlocProvider<IPGeoLocationBloc>(
      create: (context) => IPGeoLocationBloc(),
    ),
    BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(),
    ),
    BlocProvider<MultimediaBloc>(
      create: (context) => MultimediaBloc(),
    ),
    BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
    ),
    BlocProvider<UnreadMessageBloc>(
      create: (context) => UnreadMessageBloc(),
    ),
    BlocProvider<UserBloc>(
      create: (context) => UserBloc(),
    ),
    BlocProvider<UserContactBloc>(
      create: (context) => UserContactBloc(),
    ),
    BlocProvider<WebSocketBloc>(
      create: (context) => WebSocketBloc(),
    ),
    BlocProvider<PhoneStorageContactBloc>(
      create: (context) => PhoneStorageContactBloc(),
    ),
    BlocProvider<MultimediaProgressBloc>(
      create: (context) => MultimediaProgressBloc(),
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
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
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
        "photo_view_page": (_) => new PhotoViewPage(),
        "video_player_page": (_) => new VideoPlayerPage(),
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
