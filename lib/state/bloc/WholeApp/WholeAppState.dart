
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/user/user.dart';

class WholeAppState {
  List<Conversation> conversationList;
  List<Message> messageList;
  List<UserContact> userContactList;
  List<Contact> phoneContactList;
  Settings settingsState;
  User userState;


  WholeAppState._();
  // factory constructor https://stackoverflow.com/questions/52299304/dart-advantage-of-a-factory-constructor-identifier
  // What is double dot? https://stackoverflow.com/questions/49447736/list-use-of-double-dot-in-dart
  factory WholeAppState.initial() {
    return WholeAppState._()
      ..conversationList = []
      ..messageList = []
      ..userContactList = []
      ..phoneContactList = []
      ..settingsState = new Settings()
      ..userState = new User(
          googleSignIn: new GoogleSignIn(),
          firebaseAuth: FirebaseAuth.instance);
  }
}
