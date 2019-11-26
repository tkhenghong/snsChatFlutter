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

class AddUnreadMessageEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  AddUnreadMessageEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'AddUnreadMessageToStateEvent {unreadMessage: $unreadMessage}';
}

class EditUnreadMessageEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  EditUnreadMessageEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'EditUnreadMessageToStateEvent {unreadMessage: $unreadMessage}';
}

class DeleteUnreadMessageEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  DeleteUnreadMessageEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'DeleteUnreadMessageToStateEvent {unreadMessage: $unreadMessage}';
}
