import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

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
  String toString() => 'AddUserContactEvent {userContact: $userContact}';
}

class AddMultipleUserContactEvent extends UserContactEvent {
  final List<UserContact> userContactList;
  final Function callback;

  AddMultipleUserContactEvent({this.userContactList, this.callback});

  @override
  List<Object> get props => [userContactList];

  @override
  String toString() => 'AddMultipleUserContactEvent {userContactList: $userContactList}';
}

class EditUserContactEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  EditUserContactEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'EditUserContactEvent {userContact: $userContact}';
}

class DeleteUserContactEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  DeleteUserContactEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'DeleteUserContactEvent {userContact: $userContact}';
}

class GetUserContactEvent extends UserContactEvent {
  final String userContactId;
  final Function callback;

  GetUserContactEvent({this.userContactId, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetUserContactEvent {userContactId: ${userContactId}}';
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

class GetUserPreviousUserContactsEvent extends UserContactEvent {
  final User user;
  final Function callback;

  GetUserPreviousUserContactsEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GetUserPreviousUserContactsEvent {user: $user}';
}
