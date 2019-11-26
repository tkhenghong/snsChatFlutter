import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class SettingsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const SettingsEvent();
}

class InitializeSettingssEvent extends SettingsEvent {
  final User user; // Must have User object to load correct Settings to State
  final Function callback;

  const InitializeSettingssEvent({this.user, this.callback});

  @override
  String toString() => 'InitializeSettingssEvent';
}

class AddSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  AddSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'AddSettingsToStateEvent {settings: $settings}';
}

class EditSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  EditSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'EditSettingsToStateEvent {settings: $settings}';
}

class DeleteSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  DeleteSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'DeleteSettingsToStateEvent {settings: $settings}';
}
