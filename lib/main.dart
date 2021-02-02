import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/i18n/app_locale/app_locale.dart';
import 'package:snschat_flutter/objects/models/environment_global_variables/environment_global_variables.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:snschat_flutter/state/bloc/index.dart';
import 'package:snschat_flutter/state/provider/index.dart';
import 'package:snschat_flutter/theme/index.dart';
import 'package:snschat_flutter/ui/pages/index.dart';

import 'database/sembast/index.dart';
import 'init.dart';
import 'navigation/index.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() async {
  initEnvironment();
  EnvironmentGlobalVariables env = Get.find();

  generateRoutes();
  generateGetPageList();
  WidgetsFlutterBinding.ensureInitialized();

  initProviders();

  ByteData byteData = await rootBundle.load(env.sslCertificateLocation);
  HttpOverrides.global = new CustomHttpOverrides(byteData);
  _enablePlatformOverrideForDesktop();
  init3rdPartyServices();
  initializeServices();
  initAPIServices();
  initDBServices();

  Bloc.observer = SimpleBlocObserver();

  runApp(Phoenix(
    child: GetMaterialApp(
      home: initializeBlocProviders(),
      getPages: getPageList,
      theme: themeData,
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  EnvironmentGlobalVariables environmentGlobalVariables = Get.find();
  LanguageProvider languageProvider = Get.find();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      setDisplayMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return appLanguageProvider();
  }

  appLanguageProvider() {
    print('environmentGlobalVariables.locales: ${environmentGlobalVariables.locales}');
    List<Locale> locales = environmentGlobalVariables.locales.map((e) => Locale(e)).toList();

    return ChangeNotifierProvider<LanguageProvider>(
        create: (context) => languageProvider,
        child: Consumer<LanguageProvider>(
          builder: (context, language, child) {
            return MaterialApp(
              title: 'PocketChat',
              locale: language.appLocale,
              supportedLocales: locales,
              localizationsDelegates: [
                AppLocale.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              theme: themeData,
              home: TabsPage(),
              routes: routeList,
            );
          },
        ));
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

      if (!isObjectEmpty(enableFullFPS) && enableFullFPS) {
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
