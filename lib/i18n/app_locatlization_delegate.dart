import 'package:flutter/material.dart';
import 'package:snschat_flutter/environments/environment_config.dart';
import 'package:snschat_flutter/i18n/app_locale/app_locale.dart';

// Main reference: https://medium.com/flutter-community/flutter-internationalization-the-easy-way-using-provider-and-json-c47caa4212b2
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocale> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    // Note: Unable to bring List<String> locales from constructor.
    return EnvironmentConfig().environmentGlobalVariables.locales.contains(locale.languageCode);
  }

  @override
  Future<AppLocale> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocale localizations = new AppLocale(locale: locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
