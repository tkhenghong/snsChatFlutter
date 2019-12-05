import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';

import 'bloc.dart';
import 'package:bloc/bloc.dart';

// Idea from Official Documentation. Link: https://bloclibrary.dev/#/fluttertodostutorial
class GoogleInfoBloc extends Bloc<GoogleInfoEvent, GoogleInfoState> {
  ConversationDBService conversationGroupDBService = new ConversationDBService();

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
    }

    // GetOwnGoogleInfoEvent
  }

  Stream<GoogleInfoState> _mapInitializeGoogleInfoToState(InitializeGoogleInfoEvent event) async* {
    print('GoogleInfoBloc.dart _mapInitializeGoogleInfoToState()');
    if(state is GoogleInfoNotLoaded || state is GoogleInfoLoading) {
      print('GoogleInfoBloc.dart if(state is GoogleInfoNotLoaded || state is GoogleInfoLoading)');
      try {
        // TODO: Google Sign in
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
          Fluttertoast.showToast(msg: 'Google sign in canceled.', toastLength: Toast.LENGTH_SHORT);
          yield GoogleInfoNotLoaded();
        }

        GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

        AuthResult authResult = await firebaseAuth.signInWithCredential(credential);
        firebaseUser = authResult.user;

        print('GoogleInfoBloc.dart SUCCESS');
        yield GoogleInfoLoaded(googleSignIn, firebaseAuth, firebaseUser);
//        yield GoogleInfoNotLoaded();
        if (!isObjectEmpty(event)) {
          print('Test!!!!!!!!!!!!!!!!!!!');
          event.callback(true);
        }

      } catch (e) {
        functionCallback(event, false);
        yield GoogleInfoNotLoaded();
      }
    }
  }

  Stream<GoogleInfoState> _removeGoogleInfoFromState(RemoveGoogleInfoEvent event) async* {
    if (state is GoogleInfoLoaded) {
      try {
        GoogleSignIn googleSignIn = (state as GoogleInfoLoaded).googleSignIn;
        FirebaseAuth firebaseAuth = (state as GoogleInfoLoaded).firebaseAuth;
        FirebaseUser firebaseUser = (state as GoogleInfoLoaded).firebaseUser;

        firebaseAuth.signOut();
        firebaseUser.delete();
        googleSignIn.disconnect();
        googleSignIn.signOut();

        firebaseUser = null;
      } catch (e) {
        print('RemoveGoogleInfoEvent error.');
        print('Error: ' + e);
      }

      functionCallback(event, true);

      yield GoogleInfoNotLoaded();
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



  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
