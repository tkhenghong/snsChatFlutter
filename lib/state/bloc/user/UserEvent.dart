import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class AddUserEvent extends UserEvent {
  final User user;
  final Function callback;

  AddUserEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'AddUserToStateEvent {user: $user}';
}


// Used for edit user for API, DB and State
class EditUserToStateEvent extends UserEvent {
  final User user;
  final Function callback;

  EditUserToStateEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'EditUserToStateEvent {user: $user}';
}

class DeleteUserFromStateEvent extends UserEvent {
  final User user;
  final Function callback;

  DeleteUserFromStateEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'DeleteUserToStateEvent {user: $user}';
}

class GetOwnUserEvent extends UserEvent {
  final FirebaseUser firebaseUser;
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final Function callback;

  GetOwnUserEvent({this.googleSignIn, this.firebaseAuth, this.firebaseUser, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetOwnUserEvent';
}

class CheckUserSignedUp extends UserEvent {
  final String mobileNo;
  final Function callback;

  CheckUserSignedUp({this.mobileNo, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'CheckUserSignedUp';
}