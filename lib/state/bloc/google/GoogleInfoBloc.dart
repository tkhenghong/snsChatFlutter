import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/general/index.dart';

import 'bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class GoogleInfoBloc extends Bloc<GoogleInfoEvent, GoogleInfoState> {
  @override
  GoogleInfoState get initialState => GoogleInfoLoading();

  @override
  Stream<GoogleInfoState> mapEventToState(GoogleInfoEvent event) async* {
    if (event is InitializeGoogleInfoEvent) {
      yield* _mapInitializeGoogleInfoToState(event);
    } else if (event is RemoveGoogleInfoEvent) {
      yield* _removeGoogleInfoFromState(event);
    } else if (event is GetOwnGoogleInfoEvent) {
      yield* _getOwnGoogleInfo(event);
    } else if (event is SignInGoogleInfoEvent) {
      yield* _signIntoGoogle(event);
    }
  }

  Stream<GoogleInfoState> _mapInitializeGoogleInfoToState(InitializeGoogleInfoEvent event) async* {
    if (state is GoogleInfoNotLoaded || state is GoogleInfoLoading) {
      try {
        // TODO: Google Sign in
        GoogleSignIn googleSignIn = new GoogleSignIn();
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        FirebaseUser firebaseUser;

        GoogleSignInAccount googleSignInAccount;

        if (!await googleSignIn.isSignedIn()) {
          yield GoogleInfoNotLoaded();
          functionCallback(event, false);
        } else {
          // For chat group list page
          googleSignInAccount = await googleSignIn.signInSilently(suppressErrors: false);

          if (isObjectEmpty(googleSignInAccount)) {
            showToast('Google sign in canceled.', Toast.LENGTH_SHORT);
            yield GoogleInfoNotLoaded();
            functionCallback(event, false);
          } else {
            GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

            AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

            AuthResult authResult = await firebaseAuth.signInWithCredential(credential);
            firebaseUser = authResult.user;

            yield GoogleInfoLoaded(googleSignIn, firebaseAuth, firebaseUser);
            if (!isObjectEmpty(event)) {
              event.callback(true);
            }
          }
        }
      } catch (e) {
        yield GoogleInfoNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  Stream<GoogleInfoState> _removeGoogleInfoFromState(RemoveGoogleInfoEvent event) async* {
    if (state is GoogleInfoLoaded) {
      try {
        GoogleSignIn googleSignIn = (state as GoogleInfoLoaded).googleSignIn;
        FirebaseAuth firebaseAuth = (state as GoogleInfoLoaded).firebaseAuth;

        firebaseAuth.signOut();
        googleSignIn.disconnect();
        googleSignIn.signOut();
      } catch (e) {
        print('RemoveGoogleInfoEvent error.');
        print('Error: ' + e);
      }

      yield GoogleInfoNotLoaded();
      functionCallback(event, true);
    }
  }

  Stream<GoogleInfoState> _getOwnGoogleInfo(GetOwnGoogleInfoEvent event) async* {
    if (state is GoogleInfoLoaded) {
      // GetOwnGoogleInfo
      try {
        GoogleSignIn googleSignIn = (state as GoogleInfoLoaded).googleSignIn;
        FirebaseAuth firebaseAuth = (state as GoogleInfoLoaded).firebaseAuth;
        FirebaseUser firebaseUser = (state as GoogleInfoLoaded).firebaseUser;

        if (!isObjectEmpty(event)) {
          event.callback(googleSignIn, firebaseAuth, firebaseUser);
        }

//        functionCallback(event, {googleSignIn, firebaseAuth, firebaseUser});
      } catch (e) {
        print('GetOwnGoogleInfoEvent error.');
        print('Error: ' + e);
      }
    }
  }

  Stream<GoogleInfoState> _signIntoGoogle(SignInGoogleInfoEvent event) async* {
    if (state is GoogleInfoNotLoaded || state is GoogleInfoLoading) {
      try {
        GoogleSignIn googleSignIn = new GoogleSignIn();
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        FirebaseUser firebaseUser;

        GoogleSignInAccount googleSignInAccount;

        if (!await googleSignIn.isSignedIn()) {
          // For login page
          googleSignInAccount = await googleSignIn.signIn();
        } else {
          // For chat group list page
          googleSignInAccount = await googleSignIn.signInSilently(suppressErrors: false);
        }

        if (isObjectEmpty(googleSignInAccount)) {
          showToast('Google sign in canceled.', Toast.LENGTH_SHORT);
          yield GoogleInfoNotLoaded();
          functionCallback(event, false);
        }

        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

        AuthResult authResult = await firebaseAuth.signInWithCredential(credential);
        firebaseUser = authResult.user;

        yield GoogleInfoLoaded(googleSignIn, firebaseAuth, firebaseUser);
        if (!isObjectEmpty(event)) {
          event.callback(true);
        }
      } catch (e) {
        yield GoogleInfoNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
