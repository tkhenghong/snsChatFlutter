import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

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

class AddMessageToStateEvent extends MessageEvent {
  final Message message;
  final Function callback;

  AddMessageToStateEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddMessageToStateEvent {message: $message}';
}

class EditMessageToStateEvent extends MessageEvent {
  final Message message;
  final Function callback;

  EditMessageToStateEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'EditMessageToStateEvent {message: $message}';
}

class DeleteMessageToStateEvent extends MessageEvent {
  final Message message;
  final Function callback;

  DeleteMessageToStateEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteMessageToStateEvent {message: $message}';
}

class SendMessageEvent extends MessageEvent {
  final Message message;
  final Function callback;

  SendMessageEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'SendMessageEvent {message: $message}';
}
