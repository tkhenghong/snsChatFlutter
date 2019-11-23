import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/conversationGroup/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

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

class AddConversationGroupToStateEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final Function callback;

  const AddConversationGroupToStateEvent({this.conversationGroup, this.callback});

  @override
  List<Object> get props => [conversationGroup];

  @override
  String toString() => 'AddConversationGroupToStateEvent {conversationGroup: $conversationGroup}';
}

class EditConversationGroupEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final Function callback;

  EditConversationGroupEvent({this.conversationGroup, this.callback});

  @override
  List<Object> get props => [conversationGroup];

  @override
  String toString() => 'EditConversationGroupEvent {conversationGroup: $conversationGroup}';
}

class DeleteConversationGroupEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final Function callback;

  DeleteConversationGroupEvent(this.conversationGroup, this.callback);

  @override
  List<Object> get props => [conversationGroup];

  @override
  String toString() => 'DeleteConversationGroupEvent {conversationGroup: $conversationGroup}';
}

class CreateConversationGroupEvent extends ConversationGroupEvent {
  final ConversationGroup conversationGroup;
  final String type;
  final List<Contact> contactList;
  final Multimedia multimedia;
  final File imageFile;
  final Function callback;

  CreateConversationGroupEvent({this.conversationGroup, this.type, this.contactList, this.imageFile, this.multimedia, this.callback});

  @override
  List<Object> get props => [conversationGroup, type, contactList, imageFile, multimedia];

  @override
  String toString() => 'CreateConversationGroupEvent {conversationGroup: $conversationGroup}';
}
