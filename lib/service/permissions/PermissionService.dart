import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestContactPermission() async {
    return await Permission.contacts.request() == PermissionStatus.granted;
  }

  Future<bool> requestStoragePermission() async {
    return await Permission.storage.request() == PermissionStatus.granted;
  }

  Future<bool> requestCameraPermission() async {
    return await Permission.camera.request() == PermissionStatus.granted;
  }

  Future<bool> requestMicrophonePermission() async {
    return await Permission.microphone.request() == PermissionStatus.granted;
  }

  Future<bool> requestSMSPermission() async {
    return await Permission.sms.request() == PermissionStatus.granted;
  }

  Future<bool> requestLocationWhenInUsePermission() async {
    return await Permission.locationWhenInUse.request() ==
        PermissionStatus.granted;
  }

  Future<bool> requestPhotosPermission() async {
    return await Permission.photos.request() == PermissionStatus.granted;
  }
}
