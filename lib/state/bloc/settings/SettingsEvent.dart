import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';

abstract class SettingsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const SettingsEvent();
}

class InitializeSettingsEvent extends SettingsEvent {
  final User user; // Must have User object to load correct Settings to State
  final Function callback;

  const InitializeSettingsEvent({this.user, this.callback});

  @override
  String toString() => 'InitializeSettingsEvent';
}

class EditSettingsEvent extends SettingsEvent {
  final UpdateSettingsRequest updateSettingsRequest;
  final Function callback;

  const EditSettingsEvent({this.updateSettingsRequest, this.callback});

  @override
  List<Object> get props => [updateSettingsRequest];

  @override
  String toString() => 'EditSettingsEvent {updateSettingsRequest: $updateSettingsRequest}';
}

class UpdateSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  const UpdateSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'UpdateSettingsEvent {settings: $settings}';
}

class DeleteSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  const DeleteSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'DeleteSettingsEvent {settings: $settings}';
}

class GetUserOwnSettingsEvent extends SettingsEvent {
  final Function callback;

  const GetUserOwnSettingsEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetSettingsOfTheUserEvent';
}

class RemoveAllSettingsEvent extends SettingsEvent {
  final Function callback;

  const RemoveAllSettingsEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveAllSettingsEvent';
}
