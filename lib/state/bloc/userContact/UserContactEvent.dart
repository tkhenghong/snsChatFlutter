import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class UserContactEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const UserContactEvent();
}

class InitializeUserContactsEvent extends UserContactEvent {
  final Function callback;

  const InitializeUserContactsEvent({this.callback});

  @override
  String toString() => 'InitializeUserContactsEvent';
}

class AddUserContactToStateEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  AddUserContactToStateEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'AddUserContactToStateEvent {userContact: $userContact}';
}

class EditUserContactToStateEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  EditUserContactToStateEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'EditUserContactToStateEvent {userContact: $userContact}';
}

class DeleteUserContactToStateEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  DeleteUserContactToStateEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'DeleteUserContactToStateEvent {userContact: $userContact}';
}

class GetOwnUserContactEvent extends UserContactEvent {
  final User user;
  final Function callback;

  GetOwnUserContactEvent({this.user, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetOwnUserContactEvent';
}
