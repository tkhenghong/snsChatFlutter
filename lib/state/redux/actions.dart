import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserInitializedAction {}

class UserLoginAction {
  GoogleSignIn _googleSignIn; // = new GoogleSignIn();
  FirebaseAuth _firebaseAuth; // = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

//  UserLoginAction(this._googleSignIn, this._firebaseAuth, this._firebaseUser) {
  UserLoginAction() {
    print("Logging in.");
  }
//
//  GoogleSignIn get googleSignIn => _googleSignIn;
//  FirebaseAuth get firebaseAuth => _firebaseAuth;
//  FirebaseUser get firebaseUser => _firebaseUser;
}

class UserLogOutAction {
  UserLogOutAction() {
    print('Logging out.');
  }
}
