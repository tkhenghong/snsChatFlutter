import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

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

class GetUserPreviousConversationGroupsEvent extends ConversationGroupEvent {
  final User user;
  final Function callback;

  const GetUserPreviousConversationGroupsEvent({this.user, this.callback});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'GetUserPreviousConversationGroupsEvent {user: $user}';
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