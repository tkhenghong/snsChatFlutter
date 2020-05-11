import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class UnreadMessageState extends Equatable {
  const UnreadMessageState();

  @override
  List<Object> get props => [];
}

class UnreadMessageLoading extends UnreadMessageState {}

class UnreadMessagesLoaded extends UnreadMessageState {
  final List<UnreadMessage> unreadMessageList;

  const UnreadMessagesLoaded([this.unreadMessageList = const []]);

  @override
  List<Object> get props => [unreadMessageList];

  @override
  String toString() => 'UnreadMessagesLoaded {unreadMessageList: $unreadMessageList}';
}

class UnreadMessagesNotLoaded extends UnreadMessageState {}
