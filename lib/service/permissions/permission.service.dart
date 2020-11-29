import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> isContactPermissionGranted() async {
    return await Permission.contacts.isGranted;
  }

  Future<bool> requestContactPermission() async {
    return await Permission.contacts.request() == PermissionStatus.granted;
  }

  Future<bool> isStoragePermissionGranted() async {
    return await Permission.storage.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    return await Permission.storage.request() == PermissionStatus.granted;
  }

  Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }

  Future<bool> requestCameraPermission() async {
    return await Permission.camera.request() == PermissionStatus.granted;
  }

  Future<bool> isMicrophonePermissionGranted() async {
    return await Permission.microphone.isGranted;
  }

  Future<bool> requestMicrophonePermission() async {
    return await Permission.microphone.request() == PermissionStatus.granted;
  }

  Future<bool> isMSMSPermissionGranted() async {
    return await Permission.sms.isGranted;
  }

  Future<bool> requestSMSPermission() async {
    return await Permission.sms.request() == PermissionStatus.granted;
  }

  Future<bool> isMLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    return await Permission.location.request() == PermissionStatus.granted;
  }

  Future<bool> isMLocationWhenInUsePermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  Future<bool> requestLocationWhenInUsePermission() async {
    return await Permission.locationWhenInUse.request() == PermissionStatus.granted;
  }

  Future<bool> isMPhotosPermissionGranted() async {
    return await Permission.photos.isGranted;
  }

  Future<bool> requestPhotosPermission() async {
    return await Permission.photos.request() == PermissionStatus.granted;
  }
}
