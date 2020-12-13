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

class UpdateChatMessageEvent extends ChatMessageEvent {
  final ChatMessage chatMessage;
  final Function callback;

  UpdateChatMessageEvent({this.chatMessage, this.callback});

  @override
  List<Object> get props => [chatMessage];

  @override
  String toString() => 'UpdateChatMessageEvent {chatMesage: $chatMessage}';
}


class DeleteChatMessageEvent extends ChatMessageEvent {
  final ChatMessage chatMessage;
  final Function callback;

  DeleteChatMessageEvent({this.chatMessage, this.callback});

  @override
  List<Object> get props => [chatMessage];

  @override
  String toString() => 'DeleteChatMessageEvent {chatMessage: $chatMessage}';
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
