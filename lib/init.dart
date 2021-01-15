import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

init3rdPartyServices() {
  // Secure Storage
  Get.put(new FlutterSecureStorage());

  // Dio
  Get.put(new Dio());

  // Firebase Notification
  Get.put(FirebaseMessaging());

  // ImagePicker
  Get.put(ImagePicker());
}
