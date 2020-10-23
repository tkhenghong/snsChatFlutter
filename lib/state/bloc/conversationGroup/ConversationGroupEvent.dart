import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';

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

// Used to add conversationGroup from WebSocket
class AddConversationGroupEvent extends ConversationGroupEvent {
  final CreateConversationGroupRequest createConversationGroupRequest;
  final Function callback;

  const AddConversationGroupEvent({this.createConversationGroupRequest, this.callback});

  @override
  List<Object> get props => [createConversationGroupRequest];

  @override
  String toString() => 'AddConversationGroupEvent {createConversationGroupRequest: $createConversationGroupRequest}';
}

class CreateConversationGroupEvent extends ConversationGroupEvent {
  final CreateConversationGroupRequest createConversationGroupRequest;
  final Function callback;

  const CreateConversationGroupEvent({this.createConversationGroupRequest, this.callback});

  @override
  List<Object> get props => [createConversationGroupRequest];

  @override
  String toString() => 'CreateConversationGroupEvent {createConversationGroupRequest: $createConversationGroupRequest}';
}

class EditConversationGroupEvent extends ConversationGroupEvent {
  final EditConversationGroupRequest editConversationGroupRequest;
  final Function callback;

  const EditConversationGroupEvent({this.editConversationGroupRequest, this.callback});

  @override
  List<Object> get props => [editConversationGroupRequest];

  @override
  String toString() => 'EditConversationGroupEvent {editConversationGroupRequest: $editConversationGroupRequest}';
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
  final GetConversationGroupsRequest getConversationGroupsRequest;
  final Function callback;

  const GetUserOwnConversationGroupsEvent({this.getConversationGroupsRequest, this.callback});

  @override
  List<Object> get props => [getConversationGroupsRequest];

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

class RemoveConversationGroupsEvent extends ConversationGroupEvent {
  final Function callback;

  const RemoveConversationGroupsEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveConversationGroupsEvent {}';
}
