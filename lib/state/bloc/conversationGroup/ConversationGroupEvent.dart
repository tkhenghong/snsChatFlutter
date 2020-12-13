import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
abstract class ConversationGroupEvent extends Equatable {
  @override
  List<Object> get props => [];

  const ConversationGroupEvent();
}

class LoadConversationGroupsEvent extends ConversationGroupEvent {
  final int page;
  final int size;
  final Function callback;

  const LoadConversationGroupsEvent({this.page, this.size, this.callback});

  @override
  List<Object> get props => [page, size];

  @override
  String toString() => 'LoadConversationGroupsEvent {page: $page, size: $size}';
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

class UpdateConversationGroupEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final Function callback;

  const UpdateConversationGroupEvent({this.conversationGroup, this.callback});

  @override
  List<Object> get props => [conversationGroup];

  @override
  String toString() => 'UpdateConversationGroupEvent {conversationGroup: $conversationGroup}';
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

class AddGroupMembersEvent extends ConversationGroupEvent {
  final List<String> userContactIds;
  final String conversationGroupId;
  final Function callback;

  const AddGroupMembersEvent({this.userContactIds, this.conversationGroupId, this.callback});

  @override
  List<Object> get props => [userContactIds, conversationGroupId];

  @override
  String toString() => 'AddGroupMembersEvent {userContactIds: $userContactIds, conversationGroupId: $conversationGroupId}';
}

class GetSingleConversationGroupEvent extends ConversationGroupEvent {
  final String conversationGroupId;
  final Function callback;

  const GetSingleConversationGroupEvent({this.conversationGroupId, this.callback});

  @override
  List<Object> get props => [conversationGroupId];

  @override
  String toString() => 'GetSingleConversationGroupEvent {conversationGroupId: $conversationGroupId}';
}

class RemoveConversationGroupsEvent extends ConversationGroupEvent {
  final Function callback;

  const RemoveConversationGroupsEvent({this.callback});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'RemoveConversationGroupsEvent {}';
}
