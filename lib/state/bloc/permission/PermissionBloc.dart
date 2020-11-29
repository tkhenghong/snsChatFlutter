import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/service/index.dart';

import 'bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionsLoading());

  PermissionService permissionService = Get.find();

  @override
  Stream<PermissionState> mapEventToState(PermissionEvent event) async* {
    if (event is LoadPermissionsEvent) {
      yield* _loadPermissions(event);
    } else if (event is RequestCameraPermissionEvent) {
      yield* _requestCameraPermission(event);
    }
  }

  Stream<PermissionState> _loadPermissions(LoadPermissionsEvent event) async* {
    try {
      bool hasContactPermission = await permissionService.isContactPermissionGranted();
      bool hasStoragePermission = await permissionService.isStoragePermissionGranted();
      bool hasCameraPermission = await permissionService.isCameraPermissionGranted();
      bool hasMicrophonePermission = await permissionService.isMicrophonePermissionGranted();
      bool hasSMSPermission = await permissionService.isMSMSPermissionGranted();
      bool hasLocationPermission = await permissionService.isMLocationPermissionGranted();
      bool hasLocationWhenInUsePermission = await permissionService.isMLocationWhenInUsePermissionGranted();
      bool hasPhotosPermission = await permissionService.isMPhotosPermissionGranted();

      yield PermissionsLoaded(
        hasCameraPermission: hasCameraPermission,
        hasStoragePermission: hasStoragePermission,
        hasContactPermission: hasContactPermission,
        hasMicrophonePermission: hasMicrophonePermission,
        hasSMSPermission: hasSMSPermission,
        hasLocationPermission: hasLocationPermission,
        hasLocationWhenInUsePermission: hasLocationWhenInUsePermission,
        hasPhotosPermission: hasPhotosPermission,
      );
      functionCallback(event, true);
    } catch (e) {
      yield PermissionsNotLoaded();
      functionCallback(event, false);
    }
  }

  Stream<PermissionState> _requestCameraPermission(RequestCameraPermissionEvent event) async* {
    try {
      bool hasCameraPermission = await permissionService.requestCameraPermission();

      if (!hasCameraPermission) {
        showToast('Please allow camera permission to scan barcodes.', Toast.LENGTH_LONG);
      }

      yield* updatePermissionsLoadedState(hasCameraPermission: hasCameraPermission);
      functionCallback(event, true);
    } catch (e) {
      showToast('Unable to request camera permission. Please try again.', Toast.LENGTH_LONG);
      functionCallback(event, false);
    }
  }

  Stream<PermissionState> updatePermissionsLoadedState(
      {bool hasCameraPermission, bool hasStoragePermission, bool hasContactPermission, bool hasMicrophonePermission, bool hasSMSPermission, bool hasLocationPermission, bool hasLocationWhenInUsePermission, bool hasPhotosPermission}) async* {
    if (state is PermissionsLoaded) {
      PermissionsLoaded currentState = state as PermissionsLoaded;

      bool existingCameraPermission = currentState.hasCameraPermission;
      bool existingStoragePermission = currentState.hasStoragePermission;
      bool existingContactPermission = currentState.hasContactPermission;
      bool existingMicrophonePermission = currentState.hasMicrophonePermission;
      bool existingSMSPermission = currentState.hasSMSPermission;
      bool existingLocationPermission = currentState.hasLocationPermission;
      bool existingLocationWhenInUsePermission = currentState.hasLocationWhenInUsePermission;
      bool existingPhotosPermission = currentState.hasPhotosPermission;

      if (!isObjectEmpty(hasCameraPermission)) {
        existingCameraPermission = hasCameraPermission;
      }

      if (!isObjectEmpty(hasStoragePermission)) {
        existingStoragePermission = hasStoragePermission;
      }

      if (!isObjectEmpty(hasContactPermission)) {
        existingContactPermission = hasContactPermission;
      }

      if (!isObjectEmpty(hasMicrophonePermission)) {
        existingMicrophonePermission = hasMicrophonePermission;
      }

      if (!isObjectEmpty(hasSMSPermission)) {
        existingSMSPermission = hasSMSPermission;
      }

      if (!isObjectEmpty(hasLocationPermission)) {
        existingLocationPermission = hasLocationPermission;
      }

      if (!isObjectEmpty(hasLocationWhenInUsePermission)) {
        existingLocationWhenInUsePermission = hasLocationWhenInUsePermission;
      }

      if (!isObjectEmpty(hasPhotosPermission)) {
        existingPhotosPermission = hasPhotosPermission;
      }

      yield PermissionsLoaded(
        hasCameraPermission: existingCameraPermission,
        hasStoragePermission: existingStoragePermission,
        hasContactPermission: existingContactPermission,
        hasMicrophonePermission: existingMicrophonePermission,
        hasSMSPermission: existingSMSPermission,
        hasLocationPermission: existingLocationPermission,
        hasLocationWhenInUsePermission: existingLocationWhenInUsePermission,
        hasPhotosPermission: existingPhotosPermission,
      );
    } else {
      yield PermissionsLoaded(
        hasCameraPermission: hasCameraPermission,
        hasStoragePermission: hasStoragePermission,
        hasContactPermission: hasContactPermission,
        hasMicrophonePermission: hasMicrophonePermission,
        hasSMSPermission: hasSMSPermission,
        hasLocationPermission: hasLocationPermission,
        hasLocationWhenInUsePermission: hasLocationWhenInUsePermission,
        hasPhotosPermission: hasPhotosPermission,
      );
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
