import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class UnreadMessageEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const UnreadMessageEvent();
}

class InitializeUnreadMessagesEvent extends UnreadMessageEvent {
  final Function callback;

  const InitializeUnreadMessagesEvent({this.callback});

  @override
  String toString() => 'InitializeUnreadMessagesEvent';
}

class AddUnreadMessageToStateEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  AddUnreadMessageToStateEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'AddUnreadMessageToStateEvent {unreadMessage: $unreadMessage}';
}

class EditUnreadMessageToStateEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  EditUnreadMessageToStateEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'EditUnreadMessageToStateEvent {unreadMessage: $unreadMessage}';
}

class DeleteUnreadMessageToStateEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  DeleteUnreadMessageToStateEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'DeleteUnreadMessageToStateEvent {unreadMessage: $unreadMessage}';
}

// Used for edit unreadMessage for API, DB and State
class ChangeUnreadMessageEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  ChangeUnreadMessageEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'ChangeUnreadMessageEvent {unreadMessage: $unreadMessage}';
}
