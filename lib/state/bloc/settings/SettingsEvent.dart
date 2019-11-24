import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class SettingsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const SettingsEvent();
}

class InitializeSettingssEvent extends SettingsEvent {
  final Function callback;

  const InitializeSettingssEvent({this.callback});

  @override
  String toString() => 'InitializeSettingssEvent';
}

class AddSettingsToStateEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  AddSettingsToStateEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'AddSettingsToStateEvent {settings: $settings}';
}

class EditSettingsToStateEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  EditSettingsToStateEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'EditSettingsToStateEvent {settings: $settings}';
}

class DeleteSettingsToStateEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  DeleteSettingsToStateEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'DeleteSettingsToStateEvent {settings: $settings}';
}

// Used for edit settings for API, DB and State
class ChangeSettingsEvent extends SettingsEvent {
  final Settings settings;
  final Function callback;

  ChangeSettingsEvent({this.settings, this.callback});

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'ChangeSettingsEvent {settings: $settings}';
}
