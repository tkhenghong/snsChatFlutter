import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class ChatMessageEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const ChatMessageEvent();
}

class InitializeChatMessagesEvent extends ChatMessageEvent {
  final Function callback;

  const InitializeChatMessagesEvent({this.callback});

  @override
  String toString() => 'InitializeChatMessagesEvent';
}

class AddChatMessageEvent extends ChatMessageEvent {
  final ChatMessage message;
  final Function callback;

  AddChatMessageEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AddChatMessageEvent {message: $message}';
}

class EditChatMessageEvent extends ChatMessageEvent {
  final ChatMessage message;
  final Function callback;

  EditChatMessageEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'EditChatMessageEvent {message: $message}';
}

class DeleteChatMessageEvent extends ChatMessageEvent {
  final ChatMessage message;
  final Function callback;

  DeleteChatMessageEvent({this.message, this.callback});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'DeleteChatMessageEvent {message: $message}';
}

class GetUserOwnChatMessagesEvent extends ChatMessageEvent {
  final User user;
  final Function callback;

  GetUserOwnChatMessagesEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GetUserOwnChatMessagesEvent {user: $user}';
}
class RemoveAllChatMessagesEvent extends ChatMessageEvent {
  final Function callback;

  RemoveAllChatMessagesEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveAllChatMessagesEvent';
}
