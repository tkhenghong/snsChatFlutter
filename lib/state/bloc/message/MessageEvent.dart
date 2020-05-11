import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class MessageEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const MessageEvent();
}

class InitializeMessagesEvent extends MessageEvent {
  final Function callback;

  const InitializeMessagesEvent({this.callback});

  @override
  String toString() => 'InitializeMessagesEvent';
}

class AddMessageEvent extends MessageEvent {
  final ChatMessage message;
  final Function callback;

  AddMessageEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddMessageEvent {message: $message}';
}

class EditMessageEvent extends MessageEvent {
  final ChatMessage message;
  final Function callback;

  EditMessageEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'EditMessageEvent {message: $message}';
}

class DeleteMessageEvent extends MessageEvent {
  final ChatMessage message;
  final Function callback;

  DeleteMessageEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteMessageEvent {message: $message}';
}


class GetUserPreviousMessagesEvent extends MessageEvent {
  final User user;
  final Function callback;

  GetUserPreviousMessagesEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GetUserPreviousMessagesEvent {user: $user}';
}