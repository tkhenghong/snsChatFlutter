import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';
import 'package:snschat_flutter/state/bloc/network/bloc.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

import 'database/sembast/index.dart';
import 'general/functions/index.dart';

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

// Default theme details in the app
Brightness primaryBrightness = Brightness.light;

// Black theme. Black is not MaterialColor, which has a list of colors within it
// https://github.com/flutter/flutter/issues/15658
int _blackPrimaryValue = 0xFF000000;
MaterialColor blackTheme = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFFF5F5F5),
    100: Color(0xFFE9E9E9),
    200: Color(0xFFD9D9D9),
    300: Color(0xFFC4C4C4),
    400: Color(0xFF9D9D9D),
    500: Color(0xFF7B7B7B),
    600: Color(0xFF555555),
    700: Color(0xFF434343),
    800: Color(0xFF262626),
    900: Color(_blackPrimaryValue),
  },
);

MaterialColor themeColor = blackTheme;

TextStyle primaryTextStyleInAppBarText = TextStyle(color: themeColor, fontSize: 18.0, fontWeight: FontWeight.bold);

ThemeData themeData = ThemeData(
  fontFamily: 'Roboto',
  brightness: primaryBrightness,
  primarySwatch: themeColor,
  primaryColor: themeColor,
  accentColor: themeColor,
  cursorColor: themeColor,
  highlightColor: themeColor[500],
  textSelectionColor: themeColor[500],
  textSelectionHandleColor: themeColor,
  indicatorColor: themeColor,
  buttonColor: themeColor,
  buttonTheme: ButtonThemeData(buttonColor: themeColor, textTheme: ButtonTextTheme.primary),
  errorColor: themeColor,
  bottomAppBarColor: themeColor,
  bottomAppBarTheme: BottomAppBarTheme(
    color: themeColor,
  ),
  appBarTheme: AppBarTheme(
      color: themeColor,
      textTheme: TextTheme(
        button: primaryTextStyleInAppBarText,
      )),
);

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
      theme: themeData,
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
    BlocProvider<ChatMessageBloc>(
      create: (context) => ChatMessageBloc(),
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
  Get.put(ChatMessageAPIService());
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

  // ImagePicker
  Get.put(ImagePicker());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setDisplayMode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketChat',
      theme: themeData,
      home: TabsPage(),
      routes: routeList,
    );
  }

  /// Set display mode of the app to allow maximum fps in the app.
  Future<void> setDisplayMode() async {
    try {
      final DisplayMode currentDisplayMode = await FlutterDisplayMode.current;
      List<DisplayMode> displayModeList = await FlutterDisplayMode.supported;
      int highestWidthResolution = 0;
      double highestRefreshRate = 0;
      int selectedId = 0;

      displayModeList.forEach((displayMode) {
        if (displayMode.width > highestWidthResolution || displayMode.refreshRate > highestRefreshRate) {
          selectedId = displayMode.id;
        }

        if (displayMode.width > highestWidthResolution) {
          highestWidthResolution = displayMode.width;
        }
        if (displayMode.refreshRate > highestRefreshRate) {
          highestRefreshRate = displayMode.refreshRate;
        }
      });

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      bool enableFullFPS = sharedPreferences.get('enableFullFPS');

      if(!isObjectEmpty(enableFullFPS) && enableFullFPS) {
        await FlutterDisplayMode.setMode(displayModeList[selectedId]);
      } else {
        await FlutterDisplayMode.setMode(currentDisplayMode); // Use back user set default mode.
      }
    } on PlatformException catch (e) {
      // Do nothing.
      print('PlatformException');
      print('e.code: ' + e.code);
      print('e.message: ' + e.message);
      print('e.details: ' + e.details.toString());
    }
  }
}

class NavigationPage {
  String routeName;
  Widget routePage;

  NavigationPage({this.routeName, this.routePage});
}
