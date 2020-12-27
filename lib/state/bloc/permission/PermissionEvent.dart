// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
import 'package:equatable/equatable.dart';

abstract class PermissionEvent extends Equatable {
  @override
  List<Object> get props => [];

  const PermissionEvent();
}

class LoadPermissionsEvent extends PermissionEvent {
  final Function callback;

  const LoadPermissionsEvent({this.callback});

  @override
  String toString() => 'LoadPermissionsEvent';
}

class RequestCameraPermissionEvent extends PermissionEvent {
  final Function callback;

  const RequestCameraPermissionEvent({this.callback});

  @override
  String toString() => 'RequestCameraPermissionEvent';
}
