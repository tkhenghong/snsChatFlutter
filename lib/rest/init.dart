import 'package:get/get.dart';

import 'index.dart';

initAPIServices() {

  Get.put(CustomHttpClient());
  Get.put(HTTPFileService());
  Get.put(ConversationGroupAPIService());
  Get.put(IPLocationAPIService());
  Get.put(ChatMessageAPIService());
  Get.put(MultimediaAPIService());
  Get.put(SettingsAPIService());
  Get.put(UnreadMessageAPIService());
  Get.put(UserAPIService());
  Get.put(UserAuthenticationAPIService());
  Get.put(UserContactAPIService());

}