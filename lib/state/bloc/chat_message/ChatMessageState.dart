import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class ChatMessageState extends Equatable {
  const ChatMessageState();

  @override
  List<Object> get props => [];
}

class ChatMessageLoading extends ChatMessageState {}

class ChatMessagesLoaded extends ChatMessageState {
  final List<ChatMessage> chatMessageList;

  const ChatMessagesLoaded([this.chatMessageList = const []]);

  @override
  List<Object> get props => [chatMessageList];

  @override
  String toString() => 'ChatMessagesLoaded {chatMessageList: $chatMessageList}';
}

class ChatMessagesNotLoaded extends ChatMessageState {}
