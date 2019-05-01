import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';


//Step 1 Define what will be your app state is
class User {
  GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  User({this.firebaseAuth, this.firebaseUser, this.googleSignIn});

  // To replace the state with new object without mutate the old one (immutability)
  User copyWith(
      {GoogleSignIn firebaseAuth,
      FirebaseAuth firebaseUser,
      FirebaseUser googleSignIn}) {
    return User(
      firebaseAuth: firebaseAuth ?? this.firebaseAuth,
      // ?? symbol will auto return the one without null value
      firebaseUser: firebaseUser ?? this.firebaseUser,
      googleSignIn: googleSignIn ?? this.googleSignIn,
    );
  }
}

// Step 2: Create a total app state and define it's initial value
class AppState {
  final User user;

  AppState({
    @required this.user,
});
  // Make the initial user object empty
  AppState.initialState() : user = null;
}