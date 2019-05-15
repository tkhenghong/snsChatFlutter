import 'package:snschat_flutter/objects/chat/conversation_group.dart';

abstract class WholeAppEvent {}

class UserSignInEvent extends WholeAppEvent {
  Function callback;

  UserSignInEvent({this.callback});
}

class UserSignOutEvent extends WholeAppEvent {}

class AddConversationEvent extends WholeAppEvent {
  Conversation conversation;

  AddConversationEvent({this.conversation});
}