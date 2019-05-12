import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';

class User {
  String id;
  String displayName;
  String realName;
  String userId;
  String mobileNo;
  Settings settings;
  // Cannot initialize anything here for flutter_bloc
  GoogleSignIn googleSignIn; // = new GoogleSignIn();
  FirebaseAuth firebaseAuth; // = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  User(
      {this.id,
      this.displayName,
      this.realName,
      this.userId,
      this.mobileNo,
      this.settings,
      this.firebaseUser,
      this.googleSignIn,
      this.firebaseAuth});
}
