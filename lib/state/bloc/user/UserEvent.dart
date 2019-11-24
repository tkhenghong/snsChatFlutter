import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class UserEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const UserEvent();
}

class InitializeUserEvent extends UserEvent {
  final GoogleSignIn googleSignIn;
  final Function callback;

  const InitializeUserEvent({this.googleSignIn, this.callback});

  @override
  String toString() => 'InitializeUsersEvent. {googleSignIn: $googleSignIn}';
}

class AddUserToStateEvent extends UserEvent {
  final User user;
  final Function callback;

  AddUserToStateEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'AddUserToStateEvent {user: $user}';
}

class EditUserToStateEvent extends UserEvent {
  final User user;
  final Function callback;

  EditUserToStateEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditUserToStateEvent {user: $user}';
}

class DeleteUserToStateEvent extends UserEvent {
  final User user;
  final Function callback;

  DeleteUserToStateEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'DeleteUserToStateEvent {user: $user}';
}

// Used for edit user for API, DB and State
class ChangeUserEvent extends UserEvent {
  final User user;
  final Function callback;

  ChangeUserEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'ChangeUserEvent {user: $user}';
}
