import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snschat_flutter/i18n/app_locatlization_delegate.dart';

// Main reference: https://medium.com/flutter-community/flutter-internationalization-the-easy-way-using-provider-and-json-c47caa4212b2
// This class is a class that is following abstract class LocalizationsDelegate<T> in localizations.dart.
// NOTE: No JSON conversion and annotations on this model.
class AppLocale {
  final Locale locale;

  AppLocale({this.locale});

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocale of(BuildContext context) {
    return Localizations.of<AppLocale>(context, AppLocale);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  // static const LocalizationsDelegate<AppLocale> delegate = AppLocalizationsDelegate(locales: this.locales);
  static const LocalizationsDelegate<AppLocale> delegate = AppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle.loadString('lib/i18n/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key];
  }
}
