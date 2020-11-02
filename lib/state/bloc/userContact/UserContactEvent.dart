import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';

abstract class UserContactEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const UserContactEvent();
}

class InitializeUserContactsEvent extends UserContactEvent {
  final int page;
  final int size;
  final Function callback;

  const InitializeUserContactsEvent({this.page, this.size, this.callback});

  @override
  String toString() => 'InitializeUserContactsEvent {page: $page, size: $size}';
}

class EditOwnUserContactEvent extends UserContactEvent {
  final UserContact userContact;
  final Function callback;

  EditOwnUserContactEvent({this.userContact, this.callback});

  @override
  List<Object> get props => [userContact];

  @override
  String toString() => 'EditOwnUserContactEvent {userContact: $userContact}';
}

class GetUserContactEvent extends UserContactEvent {
  final String userContactId;
  final Function callback;

  GetUserContactEvent({this.userContactId, this.callback});

  @override
  List<Object> get props => [userContactId];

  @override
  String toString() => 'GetUserContactEvent {userContactId: ${userContactId}}';
}

class GetUserContactByUserIdEvent extends UserContactEvent {
  final User user;
  final Function callback;

  GetUserContactByUserIdEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GetUserOwnContactEvent {user: $user}';
}

class GetUserOwnUserContactEvent extends UserContactEvent {
  final Function callback;

  GetUserOwnUserContactEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetUserOwnUserContactEvent';
}

class GetUserOwnUserContactsEvent extends UserContactEvent {
  final GetUserOwnUserContactsRequest getUserOwnUserContactsRequest;
  final Function callback;

  GetUserOwnUserContactsEvent({this.getUserOwnUserContactsRequest, this.callback});

  @override
  List<Object> get props => [getUserOwnUserContactsRequest];

  @override
  String toString() => 'GetUserOwnUserContactsEvent {getUserOwnUserContactsRequest: $getUserOwnUserContactsRequest}';
}

class GetUserContactByMobileNoEvent extends UserContactEvent {
  final String mobileNo;
  final Function callback;

  GetUserContactByMobileNoEvent({this.mobileNo, this.callback});

  @override
  List<Object> get props => [mobileNo];

  @override
  String toString() => 'GetUserContactByMobileNoEvent';
}

class RemoveAllUserContactsEvent extends UserContactEvent {
  final Function callback;

  RemoveAllUserContactsEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveAllUserContactsEvent';
}

class GetConversationGroupUserContactsEvent extends UserContactEvent {
  final String conversationGroupId;
  final List<String> userContactIds;
  final Function callback;

  GetConversationGroupUserContactsEvent({this.conversationGroupId, this.userContactIds, this.callback});

  @override
  List<Object> get props => [conversationGroupId, userContactIds];

  @override
  String toString() => 'GetConversationGroupUserContactsEvent {conversationGroupId: $conversationGroupId, userContactIds: $userContactIds}';
}
