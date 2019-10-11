import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/objects/websocket/WebSocketMessage.dart';

abstract class WholeAppEvent {}

class CheckUserLoginEvent extends WholeAppEvent {
  Function callback;

  CheckUserLoginEvent({this.callback});
}

class CheckUserSignedUpEvent extends WholeAppEvent {
  String mobileNo;
  Function callback;

  CheckUserSignedUpEvent({this.callback, this.mobileNo});
}

// User Events
class UserSignInEvent extends WholeAppEvent {
  String mobileNo;
  Function callback;

  UserSignInEvent({this.callback, this.mobileNo});
}

class UserSignUpEvent extends WholeAppEvent {
  String mobileNo;
  String realName;
  Function callback;

  UserSignUpEvent({this.callback, this.mobileNo, this.realName});
}

class UserSignOutEvent extends WholeAppEvent {}

// Permissions Event
class CheckPermissionEvent extends WholeAppEvent {
  Function callback;

  CheckPermissionEvent({this.callback});
}

class RequestAllPermissionsEvent extends WholeAppEvent {
  Function callback;

  RequestAllPermissionsEvent({this.callback});
}

class GetPhoneStorageContactsEvent extends WholeAppEvent {
  Function callback;

  GetPhoneStorageContactsEvent({this.callback});
}

class GetConversationsForUserEvent extends WholeAppEvent {
  Function callback;

  GetConversationsForUserEvent({this.callback});
}

class LoadDatabaseToStateEvent extends WholeAppEvent {
  Function callback;

  LoadDatabaseToStateEvent({this.callback});
}

class LoadUserPreviousDataEvent extends WholeAppEvent {
  Function callback;

  LoadUserPreviousDataEvent({this.callback});
}

class CreateConversationGroupEvent extends WholeAppEvent {
  // TODO: Create Single Group successfully (1 ConversationGroup, 2 UserContact, 1 UnreadMessage, 1 Multimedia)
  ConversationGroup conversationGroup;
  String type;
  List<Contact> contactList;
  Multimedia multimedia;
  File imageFile;
  Function callback;

  CreateConversationGroupEvent({this.conversationGroup, this.type, this.contactList, this.imageFile, this.multimedia, this.callback});
}

class SendMessageEvent extends WholeAppEvent {
  Message message;
  Multimedia multimedia;
  Function callback;

  SendMessageEvent({this.message, this.multimedia, this.callback});
}

class ProcessMessageFromWebSocketEvent extends WholeAppEvent {
  WebSocketMessage webSocketMessage;
  Function callback;

  ProcessMessageFromWebSocketEvent({this.webSocketMessage, this.callback});
}

// Conversation
class AddConversationGroupToStateEvent extends WholeAppEvent {
  ConversationGroup conversationGroup;
  Function callback;

  AddConversationGroupToStateEvent({this.conversationGroup, this.callback});
}

class EditConversationGroupEvent extends WholeAppEvent {
  ConversationGroup conversationGroup;
  Function callback;

  EditConversationGroupEvent({this.conversationGroup, this.callback});
}

// Message

class AddMessageToStateEvent extends WholeAppEvent {
  Message message;
  Function callback;

  AddMessageToStateEvent({this.message, this.callback});
}

class EditMessageEvent extends WholeAppEvent {
  Message message;
  Function callback;

  EditMessageEvent({this.message, this.callback});
}

// Multimedia

class AddMultimediaToStateEvent extends WholeAppEvent {
  Multimedia multimedia;
  Function callback;

  AddMultimediaToStateEvent({this.multimedia, this.callback});
}

class EditMultimediaEvent extends WholeAppEvent {
  Multimedia multimedia;
  Function callback;

  EditMultimediaEvent({this.multimedia, this.callback});
}

// Unread Message
class AddUnreadMessageToStateEvent extends WholeAppEvent {
  UnreadMessage unreadMessage;
  Function callback;

  AddUnreadMessageToStateEvent({this.unreadMessage, this.callback});
}

class EditUnreadMessageEvent extends WholeAppEvent {
  UnreadMessage unreadMessage;
  Function callback;

  EditUnreadMessageEvent({this.unreadMessage, this.callback});
}

// Settings

class AddSettingsToStateEvent extends WholeAppEvent {
  Settings settings;
  Function callback;

  AddSettingsToStateEvent({this.settings, this.callback});
}

class EditSettingsEvent extends WholeAppEvent {
  Settings settings;
  Function callback;

  EditSettingsEvent({this.settings, this.callback});
}

// User

class AddUserToStateEvent extends WholeAppEvent {
  User user;
  Function callback;

  AddUserToStateEvent({this.user, this.callback});
}

class EditUserEvent extends WholeAppEvent {
  User user;
  Function callback;

  EditUserEvent({this.user, this.callback});
}

// UserContact

class AddUserContactToStateEvent extends WholeAppEvent {
  UserContact userContact;
  Function callback;

  AddUserContactToStateEvent({this.userContact, this.callback});
}

// Used to edit your own UserContact
class EditUserContactEvent extends WholeAppEvent {
  UserContact userContact;
  Function callback;

  EditUserContactEvent({this.userContact, this.callback});
}

// FirebaseAuth

class AddFirebaseAuthToStateEvent extends WholeAppEvent {
  FirebaseAuth firebaseAuth;
  Function callback;

  AddFirebaseAuthToStateEvent({this.firebaseAuth, this.callback});
}

// GoogleSignIn

class AddGoogleSignInToStateEvent extends WholeAppEvent {
  GoogleSignIn googleSignIn;
  Function callback;

  AddGoogleSignInToStateEvent({this.googleSignIn, this.callback});
}


class InitializeWebSocketServiceEvent extends WholeAppEvent {
  Function callback;

  InitializeWebSocketServiceEvent({this.callback});
}

class SendWebSocketMessageEvent extends WholeAppEvent {
  WebSocketMessage webSocketMessage;
  Function callback;

  SendWebSocketMessageEvent({this.webSocketMessage, this.callback});
}