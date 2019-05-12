import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';

class WholeAppBloc extends Bloc<WholeAppEvent, WholeAppState> {
  @override
  WholeAppState get initialState => WholeAppState.initial();

  @override
  Stream<WholeAppState> mapEventToState(WholeAppEvent event) async* {
    print('State management center!');
    if (event is UserSignInEvent) {
      print('UserSignInEvent');
      signInUsingGoogle(event);

      yield currentState;
    } else if (event is UserSignOutEvent) {
      print('UserSignOutEvent');
      signOut(event);
      yield currentState;
    }
  }

  signInUsingGoogle(UserSignInEvent event) async {
    print('signInUsingGoogle()');
    // An average user use his/her Google account to sign in.
    GoogleSignInAccount googleSignInAccount =
        await currentState.userState.googleSignIn.signIn();
    // Authenticate the user in Google
    print('Checkpoint 1');
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    print('Checkpoint 2');
    // Create credentials
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Create the user in Firebase
    currentState.userState.firebaseUser = await currentState
        .userState.firebaseAuth
        .signInWithCredential(credential);
    print('Checkpoint 3');

    print("signed in " + currentState.userState.firebaseUser.displayName);
    event.callback(); // Use callback method to signal UI change
  }

  signOut(UserSignOutEvent event) async* {
    print('signOut()');
    currentState.userState.googleSignIn.signOut();
  }
}
