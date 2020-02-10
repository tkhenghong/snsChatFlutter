import 'package:equatable/equatable.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
abstract class GoogleInfoEvent extends Equatable {
  @override
  List<Object> get props => [];

  const GoogleInfoEvent();
}

class InitializeGoogleInfoEvent extends GoogleInfoEvent {
  final Function callback;

  const InitializeGoogleInfoEvent({this.callback});

  @override
  String toString() => 'InitializeGoogleInfoEvent';
}

class SignInGoogleInfoEvent extends GoogleInfoEvent {
  final Function callback;

  const SignInGoogleInfoEvent({this.callback});

  @override
  String toString() => 'SignInGoogleInfoEvent';
}

class RemoveGoogleInfoEvent extends GoogleInfoEvent {
  final Function callback;

  RemoveGoogleInfoEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveGoogleInfoEvent';
}

class GetOwnGoogleInfoEvent extends GoogleInfoEvent {
  final Function callback;

  GetOwnGoogleInfoEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetOwnGoogleInfoEvent';
}