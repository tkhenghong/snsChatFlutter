import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/state/bloc/network/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void initializeFlutterDownloader() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize().then((data) {
    // print('FlutterDownloader.initialize() completed');
    // print('data: ' + data.toString());
  });
}

void main() async {
  _enablePlatformOverrideForDesktop();
  initializeFlutterDownloader();

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
    BlocProvider<NetworkBloc>(
      create: (context) => NetworkBloc(),
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
