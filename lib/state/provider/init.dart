import 'package:get/get.dart';
import 'package:snschat_flutter/state/provider/index.dart';

initProviders() {
  LanguageProvider languageProvider = LanguageProvider();
  languageProvider.fetchLocale();
  Get.put(languageProvider);
}
