import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/user/user.dart';

class WholeAppState {
  List<ConversationGroup> conversationGroupList;
  List<UnreadMessage> unreadMessageList;
  List<Message> messageList;
  List<Multimedia> multimediaList;
  Settings settingsState;
  User userState;
  List<UserContact> userContactList;
  List<Contact> phoneContactList; // For loading phone storage contact faster
  FirebaseUser firebaseUser;
  FirebaseAuth firebaseAuth;
  GoogleSignIn googleSignIn;

  WholeAppState._();

  // factory constructor https://stackoverflow.com/questions/52299304/dart-advantage-of-a-factory-constructor-identifier
  // What is double dot? https://stackoverflow.com/questions/49447736/list-use-of-double-dot-in-dart
  factory WholeAppState.initial() {
    return WholeAppState._()
      ..conversationGroupList = []
      ..unreadMessageList = []
      ..messageList = []
      ..multimediaList = []
      ..userContactList = []
      ..phoneContactList = []
      ..settingsState = new Settings()
      ..userState = new User()
      ..googleSignIn = new GoogleSignIn()
      ..firebaseAuth = FirebaseAuth.instance;
  }
}
