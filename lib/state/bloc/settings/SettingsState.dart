import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingssLoaded extends SettingsState {
  final List<Settings> settingsList;

  const SettingssLoaded([this.settingsList = const []]);

  @override
  List<Object> get props => [settingsList];

  @override
  String toString() => 'SettingsLoaded {settingsList: $settingsList}';
}

class SettingssNotLoaded extends SettingsState {}
