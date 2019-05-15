
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
  List<UserContact> contactList;
  Settings settingsState;
  User userState;

  WholeAppState._();

  factory WholeAppState.initial() {
    return WholeAppState._()
      ..conversationList = []
      ..messageList = []
      ..settingsState = new Settings()
      ..userState = new User(
          googleSignIn: new GoogleSignIn(),
          firebaseAuth: FirebaseAuth.instance);
  }
}
