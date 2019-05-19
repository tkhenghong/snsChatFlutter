import 'package:snschat_flutter/objects/chat/conversation_group.dart';

abstract class WholeAppEvent {}

class CheckPermissionEvent extends WholeAppEvent {
  Function callback;

  CheckPermissionEvent({this.callback});
}

class RequestPermissionsEvent extends WholeAppEvent {
  Function callback;

  RequestPermissionsEvent({this.callback});
}

class GetPhoneStorageContactsEvent extends WholeAppEvent {
  Function callback;
  GetPhoneStorageContactsEvent({this.callback});
}

class UserSignInEvent extends WholeAppEvent {
  Function callback;

  UserSignInEvent({this.callback});
}

class UserSignUpEvent extends WholeAppEvent {
  Function callback;

  UserSignUpEvent({this.callback});
}

class UserSignOutEvent extends WholeAppEvent {}

class AddConversationEvent extends WholeAppEvent {
  Conversation conversation;

  AddConversationEvent({this.conversation});
}