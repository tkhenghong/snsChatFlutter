import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
abstract class ConversationGroupState extends Equatable {
  const ConversationGroupState();

  @override
  List<Object> get props => [];
}

class ConversationGroupsLoading extends ConversationGroupState {}

class ConversationGroupsLoaded extends ConversationGroupState {
  final List<ConversationGroup> conversationGroupList;
  final int totalConversationGroups;

  const ConversationGroupsLoaded([this.conversationGroupList = const [], this.totalConversationGroups]);

  @override
  List<Object> get props => [conversationGroupList, totalConversationGroups];

  @override
  String toString() => 'ConversationGroupsLoaded {conversationGroupList: $conversationGroupList, totalConversationGroups: $totalConversationGroups}';
}

class ConversationGroupsNotLoaded extends ConversationGroupState {}
