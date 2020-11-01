import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';

abstract class ChatMessageEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const ChatMessageEvent();
}

class LoadConversationGroupChatMessagesEvent extends ChatMessageEvent {
  final String conversationGroupId;
  final Pageable pageable;
  final Function callback;

  const LoadConversationGroupChatMessagesEvent({this.conversationGroupId, this.pageable, this.callback});

  @override
  List<Object> get props => [conversationGroupId, pageable];

  @override
  String toString() => 'InitializeChatMessagesEvent {conversationGroupId: $conversationGroupId, pageable: $pageable}';
}

class AddChatMessageEvent extends ChatMessageEvent {
  final CreateChatMessageRequest createChatMessageRequest;
  final Function callback;

  AddChatMessageEvent({this.createChatMessageRequest, this.callback});

  @override
  List<Object> get props => [createChatMessageRequest];

  @override
  String toString() => 'AddChatMessageEvent {createChatMessageRequest: $createChatMessageRequest}';
}

class DeleteChatMessageEvent extends ChatMessageEvent {
  final String chatMessageId;
  final Function callback;

  DeleteChatMessageEvent({this.chatMessageId, this.callback});

  @override
  List<Object> get props => [chatMessageId];

  @override
  String toString() => 'DeleteChatMessageEvent {chatMessageId: $chatMessageId}';
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
