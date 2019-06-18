import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/chat/conversation_member.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

abstract class WholeAppEvent {}

class CheckUserLoginEvent extends WholeAppEvent {
  Function callback;

  CheckUserLoginEvent({this.callback});
}

// User Events
class UserSignInEvent extends WholeAppEvent {
  Function callback;

  UserSignInEvent({this.callback});
}

class UserSignUpEvent extends WholeAppEvent {
  User user;
  Function callback;

  UserSignUpEvent({this.callback, this.user});
}

class UserSignOutEvent extends WholeAppEvent {}

// Permissions Event
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

// Conversation
class AddConversationEvent extends WholeAppEvent {
  Conversation conversation;
  Function callback;

  AddConversationEvent({this.conversation, this.callback});
}

class AddConversationMemberEvent extends WholeAppEvent {
  ConversationMember conversationMember;
  Function callback;

  AddConversationMemberEvent({this.conversationMember, this.callback});
}

// Message

class AddMessageEvent extends WholeAppEvent {
  Message message;
  Function callback;

  AddMessageEvent({this.message, this.callback});
}

// Multimedia

class AddMultimediaEvent extends WholeAppEvent {
  Multimedia multimedia;
  Function callback;

  AddMultimediaEvent({this.multimedia, this.callback});
}

// Settings

class AddSettingsEvent extends WholeAppEvent {
  Settings settings;
  Function callback;

  AddSettingsEvent({this.settings, this.callback});
}

// User

class AddUserEvent extends WholeAppEvent {
  User user;
  Function callback;

  AddUserEvent({this.user, this.callback});
}

// Settings

class AddUserContactEvent extends WholeAppEvent {
  UserContact userContact;
  Function callback;

  AddUserContactEvent({this.userContact, this.callback});
}

// Storage Contact

class AddContactEvent extends WholeAppEvent {
  Contact contact;
  Function callback;

  AddContactEvent({this.contact, this.callback});
}

// FirebaseAuth

class AddFirebaseAuthEvent extends WholeAppEvent {
  FirebaseAuth firebaseAuth;
  Function callback;

  AddFirebaseAuthEvent({this.firebaseAuth, this.callback});
}

// GoogleSignIn

class AddGoogleSignInEvent extends WholeAppEvent {
  GoogleSignIn googleSignIn;
  Function callback;

  AddGoogleSignInEvent({this.googleSignIn, this.callback});
}

// Unread Message
class OverrideUnreadMessageEvent extends WholeAppEvent {
  UnreadMessage unreadMessage;
  Function callback;

  OverrideUnreadMessageEvent({this.unreadMessage, this.callback});
}
