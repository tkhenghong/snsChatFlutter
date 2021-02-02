import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/models/environment_global_variables/environment_global_variables.dart';

// Provider Official documentation. https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple
// Main reference: https://medium.com/flutter-community/flutter-internationalization-the-easy-way-using-provider-and-json-c47caa4212b2
class LanguageProvider extends ChangeNotifier {
  EnvironmentGlobalVariables environmentGlobalVariables = Get.find();
  Locale _appLocale = Locale('en');

  Locale get appLocale => _appLocale;

  // Init first language from environment global variable as the app language.
  LanguageProvider() {
    _appLocale = Locale(environmentGlobalVariables.locales[0]);
  }

  // Read app language preference in memory. Initialized in the app.
  fetchLocale() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (isStringEmpty(sharedPreferences.getString('language_code'))) {
      _appLocale = Locale(environmentGlobalVariables.locales[0]);
      return Null;
    }
    _appLocale = Locale(sharedPreferences.getString('language_code'));
    return Null;
  }

  // Change app language in the app instantly.
  // Configurable to be triggered when in app language settings.
  void changeLanguage(Locale locale) async {
    if (_appLocale == locale || isObjectEmpty(locale) || isStringEmpty(locale.languageCode)) {
      return;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _appLocale = Locale(locale.languageCode);
    await sharedPreferences.setString('language_code', locale.languageCode);
    await sharedPreferences.setString('country_code', locale.countryCode);

    notifyListeners();
  }
}
