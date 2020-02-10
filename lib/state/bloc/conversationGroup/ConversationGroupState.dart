import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
abstract class ConversationGroupState extends Equatable {
  const ConversationGroupState();

  @override
  List<Object> get props => [];
}

class ConversationGroupsLoading extends ConversationGroupState {}

class ConversationGroupsLoaded extends ConversationGroupState {
  final List<ConversationGroup> conversationGroupList;

  const ConversationGroupsLoaded([this.conversationGroupList = const []]);

  @override
  List<Object> get props => [conversationGroupList];

  @override
  String toString() => 'ConversationGroupsLoaded {conversationGroupList: $conversationGroupList}';
}

class ConversationGroupsNotLoaded extends ConversationGroupState {}
