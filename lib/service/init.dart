import 'package:get/get.dart';

import 'index.dart';

initializeServices() {
  Get.put(PermissionService());
  Get.put(AudioService());
  Get.put(FileCachingService());
  Get.put(CustomFileService());
  Get.put(NetworkService());
  Get.put(WebSocketService());
  Get.put(PasswordService());
  Get.put(CryptoJSService());
  Get.put(DigestService());

}