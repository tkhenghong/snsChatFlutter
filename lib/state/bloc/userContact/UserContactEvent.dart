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

class AddUserContactEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  AddUserContactEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'AddUserContactToStateEvent {userContact: $userContact}';
}

class EditUserContactEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  EditUserContactEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'EditUserContactToStateEvent {userContact: $userContact}';
}

class DeleteUserContactEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  DeleteUserContactEvent({this.userContact, this.callback});

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
