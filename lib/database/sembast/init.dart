import 'package:get/get.dart';

import 'index.dart';

initDBServices() {
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
}
