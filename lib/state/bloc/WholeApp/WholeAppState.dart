import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/user/user.dart';

class WholeAppState {
  User userState;

  WholeAppState._();

  factory WholeAppState.initial() {
    return WholeAppState._()..userState = new User(
      googleSignIn: new GoogleSignIn(),
      firebaseAuth: FirebaseAuth.instance
    );
  }
}