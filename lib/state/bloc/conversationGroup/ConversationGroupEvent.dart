import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
abstract class ConversationGroupEvent extends Equatable {
  @override
  List<Object> get props => [];

  const ConversationGroupEvent();
}

class InitializeConversationGroupsEvent extends ConversationGroupEvent {
  final Function callback;

  const InitializeConversationGroupsEvent({this.callback});

  @override
  String toString() => 'InitializeConversationGroupsEvent';
}

class AddConversationGroupEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final Function callback;

  const AddConversationGroupEvent({this.conversationGroup, this.callback});

  @override
  List<Object> get props => [conversationGroup];

  @override
  String toString() => 'AddConversationGroupEvent {conversationGroup: $conversationGroup}';
}

class EditConversationGroupEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final Function callback;

  const EditConversationGroupEvent({this.conversationGroup, this.callback});

  @override
  List<Object> get props => [conversationGroup];

  @override
  String toString() => 'EditConversationGroupEvent {conversationGroup: $conversationGroup}';
}

class DeleteConversationGroupEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final Function callback;

  const DeleteConversationGroupEvent(this.conversationGroup, this.callback);

  @override
  List<Object> get props => [conversationGroup];

  @override
  String toString() => 'DeleteConversationGroupEvent {conversationGroup: $conversationGroup}';
}

class GetUserOwnConversationGroupsEvent extends ConversationGroupEvent {
  final Function callback;

  const GetUserOwnConversationGroupsEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetUserOwnConversationGroupsEvent';
}

class AddGroupMemberEvent extends ConversationGroupEvent {
  final String userContactId;
  final String conversationGroupId;
  final Function callback;

  const AddGroupMemberEvent({this.userContactId, this.conversationGroupId, this.callback});

  @override
  List<Object> get props => [userContactId, conversationGroupId];

  @override
  String toString() => 'AddGroupMemberEvent {userContactId: $userContactId, conversationGroupId: $conversationGroupId}';
}
