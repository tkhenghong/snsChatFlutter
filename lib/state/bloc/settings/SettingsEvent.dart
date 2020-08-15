import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

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

class AddSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  const AddSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'AddSettingsEvent {settings: $settings}';
}

class EditSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  const EditSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'EditSettingsEvent {settings: $settings}';
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
