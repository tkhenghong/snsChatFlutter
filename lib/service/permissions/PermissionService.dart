import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Implementing easiest get permissions
  Future<bool> requestContactPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.contacts,
    ]);

    bool contactAccessGranted = false;
    permissions.forEach(
        (PermissionGroup permissionGroup, PermissionStatus permissionStatus) {
      if (permissionGroup == PermissionGroup.contacts &&
          permissionStatus == PermissionStatus.granted) {
        contactAccessGranted = true;
      }
    });
    return contactAccessGranted;
  }

  Future<bool> requestStoragePermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
    ]);

    bool storageAccessGranted = false;
    permissions.forEach(
            (PermissionGroup permissionGroup, PermissionStatus permissionStatus) {
          if (permissionGroup == PermissionGroup.storage &&
              permissionStatus == PermissionStatus.granted) {
            storageAccessGranted = true;
          }
        });
    return storageAccessGranted;
  }
}
