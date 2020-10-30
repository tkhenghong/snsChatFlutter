import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class UnreadMessageEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const UnreadMessageEvent();
}

class LoadUnreadMessagesEvent extends UnreadMessageEvent {
  final List<String> unreadMessageIds;
  final Function callback;

  const LoadUnreadMessagesEvent({this.unreadMessageIds, this.callback});

  @override
  List<Object> get props => [unreadMessageIds];

  @override
  String toString() => 'LoadUnreadMessagesEvent {unreadMessageIds: $unreadMessageIds}';
}

class UpdateUnreadMessageEvent extends UnreadMessageEvent {
  final UnreadMessage unreadMessage;
  final Function callback;

  UpdateUnreadMessageEvent({this.unreadMessage, this.callback});

  @override
  List<Object> get props => [unreadMessage];

  @override
  String toString() => 'UpdateUnreadMessageEvent {unreadMessage: $unreadMessage}';
}

class DeleteUnreadMessageEvent extends UnreadMessageEvent {
  final String unreadMessageId;
  final Function callback;

  DeleteUnreadMessageEvent({this.unreadMessageId, this.callback});

  @override
  List<Object> get props => [unreadMessageId];

  @override
  String toString() => 'DeleteUnreadMessageToStateEvent {unreadMessageId: $unreadMessageId}';
}

class GetUnreadMessageByConversationGroupIdEvent extends UnreadMessageEvent {
  final String conversationGroupId;
  final Function callback;

  GetUnreadMessageByConversationGroupIdEvent({this.conversationGroupId, this.callback});

  @override
  List<Object> get props => [conversationGroupId];

  @override
  String toString() => 'GetUnreadMessageByConversationGroupIdEvent {unreadMessage: $conversationGroupId}';
}

class UpdateUnreadMessagesEvent extends UnreadMessageEvent {
  final List<UnreadMessage> unreadMessages;
  final Function callback;

  UpdateUnreadMessagesEvent({this.unreadMessages, this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'UpdateUnreadMessagesEvent: {unreadMessages: $unreadMessages}';
}

class RemoveAllUnreadMessagesEvent extends UnreadMessageEvent {
  final Function callback;

  RemoveAllUnreadMessagesEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveAllUnreadMessagesEvent';
}
