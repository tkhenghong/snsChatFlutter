import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/state/bloc/user/UserEvents.dart';
import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/state/bloc/user/UserState.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // Current app states are here
  GoogleSignIn googleSignIn = new GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  String testing = "None";

  @override
  // TODO: implement initialState
  get initialState => UserInitialized();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    // Like reducer
    // TODO: implement mapEventToState
    print('UserBloc.dart mapEventToState()');
    if (event is UserLogin) {
      print('event is UserLogin');
      testing = event.testing;
      signInUsingGoogle();
      yield UserLoggedIn();
    }

    if (event is UserLogOut) {
      signOutWithGoogle();
      yield UserLoggedOut();
    }
  }

  signInUsingGoogle() async* {

    // An average user use his/her Google account to sign in.
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    // Authenticate the user in Google
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    // Create credentials
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Create the user in Firebase
    firebaseUser = await firebaseAuth.signInWithCredential(credential);
    print("signed in " + firebaseUser.displayName);
  }

  signOutWithGoogle() {
    googleSignIn.signOut();
  }
}
