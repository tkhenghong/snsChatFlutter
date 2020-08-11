import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/state/bloc/network/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

import 'database/sembast/index.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

List<NavigationPage> navigationPageList = [
  NavigationPage(routeName: 'login_page', routePage: LoginPage()),
  NavigationPage(routeName: 'privacy_notice_page', routePage: PrivacyNoticePage()),
  NavigationPage(routeName: 'sign_up_page', routePage: SignUpPage()),
  NavigationPage(routeName: 'terms_and_conditions_page', routePage: TermsAndConditionsPage()),
  NavigationPage(routeName: 'verify_phone_number_page', routePage: VerifyPhoneNumberPage()),
  NavigationPage(routeName: 'tabs_page', routePage: TabsPage()),
  NavigationPage(routeName: 'chat_group_list_page', routePage: ChatGroupListPage()),
  NavigationPage(routeName: 'scan_qr_code_page', routePage: ScanQrCodePage()),
  NavigationPage(routeName: 'settings_page', routePage: SettingsPage()),
  NavigationPage(routeName: 'myself_page', routePage: MyselfPage()),
  NavigationPage(routeName: 'chat_room_page', routePage: ChatRoomPage()),
  NavigationPage(routeName: 'chat_info_page', routePage: ChatInfoPage()),
  NavigationPage(routeName: 'contacts_page', routePage: SelectContactsPage()),
  NavigationPage(routeName: 'photo_view_page', routePage: PhotoViewPage()),
  NavigationPage(routeName: 'video_player_page', routePage: VideoPlayerPage()),
];

List<GetPage> generateGetPageList() {
  navigationPageList.forEach((element) {
    getPageList.add(GetPage(name: element.routeName, page: () => element.routePage));
  });

  return getPageList;
}

Map<String, WidgetBuilder> generateRoutes() {
  if (routeList.length == 0) {
    navigationPageList.forEach((element) {
      routeList.putIfAbsent(element.routeName, () => (_) => element.routePage);
    });
  }

  return routeList;
}

final List<GetPage> getPageList = [];
final Map<String, WidgetBuilder> routeList = new Map();

void main() async {
  generateRoutes();
  generateGetPageList();
  WidgetsFlutterBinding.ensureInitialized();
  ByteData byteData = await rootBundle.load('lib/keystore/keystore.p12');
  HttpOverrides.global = new MyHttpOverrides(byteData);
  _enablePlatformOverrideForDesktop();
  initializeServices();

  Bloc.observer = SimpleBlocObserver();

  runApp(Phoenix(
    child: GetMaterialApp(
      home: initializeBlocProviders(),
      getPages: getPageList,
    ),
  ));
}

Widget initializeBlocProviders() {
  return MultiBlocProvider(providers: [
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
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(),
    ),
    BlocProvider<NetworkBloc>(
      create: (context) => NetworkBloc(),
    ),
  ], child: MyApp());
}

initializeServices() {

  // Secure Storage
  Get.put(new FlutterSecureStorage());

  // API Services
  Get.put(CustomHttpClient());
  Get.put(ConversationGroupAPIService());
  Get.put(IPLocationAPIService());
  Get.put(MessageAPIService());
  Get.put(MultimediaAPIService());
  Get.put(SettingsAPIService());
  Get.put(UnreadMessageAPIService());
  Get.put(UserAPIService());
  Get.put(UserAuthenticationAPIService());
  Get.put(UserContactAPIService());

  // DB Services
  Get.put(ConversationDBService());
  Get.put(ChatMessageDBService());
  Get.put(MultimediaDBService());
  Get.put(MultimediaDBService());
  Get.put(MultimediaProgressDBService());
  Get.put(SettingsDBService());
  Get.put(UnreadMessageDBService());
  Get.put(UserDBService());
  Get.put(UserContactDBService());

  // Services
  Get.put(PermissionService());
  Get.put(AudioService());
  Get.put(CustomFileService());
  Get.put(FirebaseStorageService());
  Get.put(ImageService());
  Get.put(NetworkService());
  Get.put(NetworkService());
  Get.put(WebSocketService());
  Get.put(PasswordService());

  // Dio
  Get.put(new Dio());
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
            )),
      ),
      home: TabsPage(),
      routes: routeList,
    );
  }
}

class NavigationPage {
  String routeName;
  Widget routePage;

  NavigationPage({this.routeName, this.routePage});
}
