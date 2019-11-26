import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded([this.settings = const []]);

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'SettingsLoaded {settings: $settings}';
}

class SettingsNotLoaded extends SettingsState {}
