import 'package:equatable/equatable.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object> get props => [];
}

class PermissionsLoading extends PermissionState {}

class PermissionsLoaded extends PermissionState {
  final bool hasContactPermission;
  final bool hasStoragePermission;
  final bool hasCameraPermission;
  final bool hasMicrophonePermission;
  final bool hasSMSPermission;
  final bool hasLocationPermission;
  final bool hasLocationWhenInUsePermission;
  final bool hasPhotosPermission;

  const PermissionsLoaded(
      {this.hasContactPermission, this.hasStoragePermission, this.hasCameraPermission, this.hasMicrophonePermission, this.hasSMSPermission, this.hasLocationPermission, this.hasLocationWhenInUsePermission, this.hasPhotosPermission});

  @override
  List<Object> get props => [hasContactPermission, hasStoragePermission, hasCameraPermission, hasMicrophonePermission, hasSMSPermission, hasLocationPermission, hasLocationWhenInUsePermission, hasPhotosPermission];

  @override
  String toString() =>
      'PermissionsLoaded {hasContactPermission: $hasContactPermission, hasStoragePermission: $hasStoragePermission, hasCameraPermission: $hasCameraPermission, hasMicrophonePermission: $hasMicrophonePermission, hasSMSPermission: $hasSMSPermission, hasLocationPermission: $hasLocationPermission, hasLocationWhenInUsePermission: $hasLocationWhenInUsePermission, hasPhotosPermission: $hasPhotosPermission}';
}

class PermissionsNotLoaded extends PermissionState {}
