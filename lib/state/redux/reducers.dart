import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/state/model/model.dart';
import 'package:snschat_flutter/state/redux/actions.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
    user: userReducer(state.user, action),
  );
}

User userReducer(User state, action) {
  print('userReducer');
  if (action is UserLoginAction) {
    print('if (action is UserLoginAction)');
    return signInUsingGoogle(state);
  }
  if (action is UserLogOutAction) {
    print('if (action is UserLogOutAction)');
    return signOutWithGoogle(state);
  }
  print('reach no action');
  return state;
}

signInUsingGoogle(User state) async {
  print('Entered signInUsingGoogle()');
  // An average user use his/her Google account to sign in.
  GoogleSignInAccount googleSignInAccount = await state.googleSignIn.signIn();
  // Authenticate the user in Google
  GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  // Create credentials
  AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  // Create the user in Firebase
  state.firebaseUser =
      await state.firebaseAuth.signInWithCredential(credential);
  print("signed in " + state.firebaseUser.displayName);
  print("state.firebaseUser.displayName: " + state.firebaseUser.displayName);
  print("state.firebaseUser.email: " + state.firebaseUser.email);
  print("state.firebaseUser.isAnonymous: " +
      state.firebaseUser.isAnonymous.toString());
  print("state.firebaseUser.isEmailVerified: " +
      state.firebaseUser.isEmailVerified.toString());
  print("state.firebaseUser.phoneNumber: " +
      state.firebaseUser.phoneNumber.toString());
  print(
      "state.firebaseUser.photoUrl: " + state.firebaseUser.photoUrl.toString());
  print("state.firebaseUser.uid: " + state.firebaseUser.uid.toString());
  return state;
}

signOutWithGoogle(User state) {
  print('Entered signOutWithGoogle()');
  state.googleSignIn.signOut();
  return state;
}
