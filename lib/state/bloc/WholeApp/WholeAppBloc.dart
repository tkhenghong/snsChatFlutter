import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';

class WholeAppBloc extends Bloc<WholeAppEvent, WholeAppState> {
  @override
  WholeAppState get initialState => WholeAppState.initial();

  @override
  Stream<WholeAppState> mapEventToState(WholeAppEvent event) async* {
    print('State management center!');
    if (event is CheckUserLoginEvent) {
      checkUserSignIn(event);
      yield currentState;
    } else if (event is CheckUserSignedUpEvent) {
      checkUserSignedUp(event);
      yield currentState;
    } else if (event is UserSignInEvent) {
      signIn(event);
      yield currentState;
    } else if (event is UserSignOutEvent) {
      signOut(event);
      yield currentState;
    } else if (event is GetPhoneStorageContactsEvent) {
      getPhoneStorageContacts(event);
      yield currentState;
    } else if (event is RequestPermissionsEvent) {
      requestPermissions(event: event);
      yield currentState;
    } else if (event is CheckPermissionEvent) {
      checkPermissions(event);
      yield currentState;
    } else if (event is UserSignUpEvent) {
      signUpInFirestore(event);
      yield currentState;
    } else if (event is AddConversationEvent) {
      addConversation(event);
      yield currentState;
    } else if (event is AddMessageEvent) {
      addMessage(event);
      yield currentState;
    } else if (event is AddMultimediaEvent) {
      addMultimedia(event);
      yield currentState;
    } else if (event is AddSettingsEvent) {
      addSettings(event);
      yield currentState;
    } else if (event is AddUserEvent) {
      addUser(event);
      yield currentState;
    } else if (event is AddUserContactEvent) {
      addUserContact(event);
      yield currentState;
    } else if (event is AddContactEvent) {
      addContact(event);
      yield currentState;
    } else if (event is AddFirebaseAuthEvent) {
      addFirebaseAuth(event);
      yield currentState;
    } else if (event is AddGoogleSignInEvent) {
      addGoogleSignIn(event);
      yield currentState;
    } else if (event is OverrideUnreadMessageEvent) {
      overrideUnreadMessageEvent(event);
      yield currentState;
    }
  }

  // Check user is signed into the google or not
  // Because if signed in Google SDK library is programmed to remember it every time you open your app
  // Developer doesn't have save those Google data by themselves
  Future<bool> checkUserSignIn(CheckUserLoginEvent event) async {
    print('checkUserSignIn()');

    bool isSignedIn = false;

    isSignedIn = await currentState.googleSignIn.isSignedIn();
//    !isObjectEmpty(currentState.firebaseUser) && !isObjectEmpty(currentState.userState) && await currentState.googleSignIn.isSignedIn();
    if (!isSignedIn) {
      print("Not yet signed in. Go to login page...");
    } else {
      print("Signed in!");
    }
    if (!isObjectEmpty(event)) {
      event.callback(isSignedIn);
    }

    return isSignedIn;
  }

  // Use contact mobile number to check this number is signed up or not in the developer's Firebase
  Future<bool> checkUserSignedUp(CheckUserSignedUpEvent event) async {
    print("WholeAppBloc.dart checkUserSignedUp()");
    bool isSignedUp = false;
    final QuerySnapshot result = await Firestore.instance.collection('user').where('mobileNo', isEqualTo: event.mobileNo).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    print("WholeAppBloc.dart documents.length: " + documents.length.toString());
    isSignedUp = documents.length > 0;
    print("WholeAppBloc.dart isSignedUp: " + isSignedUp.toString());
    if (!isObjectEmpty(event)) {
      event.callback(isSignedUp);
    }
    return isSignedUp;
  }

  // Sign in using Google.
  // Will check user signed up or not first. If signed up, will read User data from Firebase
  // Output: The state will have GoogleAccount, FirebaseUser, User, Settings data
  Future<bool> signIn(UserSignInEvent event) async {
    CheckUserSignedUpEvent checkUserSignedUpEvent = CheckUserSignedUpEvent(callback: (bool isSignedUp) {}, mobileNo: event.mobileNo);

    bool isSignedUp = await checkUserSignedUp(checkUserSignedUpEvent);

    print("CheckUserSignedUpEvent success");

    if (isSignedUp) {
      print("if (isSignedUp)");
      bool googleSignedIn = await signInUsingGoogle();
      if (!googleSignedIn) {
        if (!isObjectEmpty(event)) {
          event.callback(false);
        }
        return false;
      }

      bool getUserSuccessful = await getUserFromFirebase();
      print("getUserFromFirebase success");
      print("currentState.userState.mobileNo: " + currentState.userState.mobileNo.toString());
      print("event.mobileNo: " + event.mobileNo.toString());

      if (getUserSuccessful) {
        print("if (getUserSuccessful)");
        // In case of Sign in from login page, check mobile no with state's mobile no got from Firebase's User table
        if (!isStringEmpty(event.mobileNo)) {
          print("if (!isStringEmpty(event.mobileNo))");
          if (currentState.userState.mobileNo.toString() != event.mobileNo.toString()) {
            print("if (currentState.userState.mobileNo != event.mobileNo)");
            if (!isObjectEmpty(event)) {
              event.callback(false);
            }
            return false;
          }
        }
        if (!isObjectEmpty(event)) {
          event.callback(true);
        }
        return true;
      } else {
        signOut(null);
      }

      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    } else {
      print("wholeAppBloc.dart if (!isSignedUp)");
      if (!isObjectEmpty(event)) {
        print("if (!isObjectEmpty(event))");
        event.callback(false);
      }
      return false;
    }
  }

  // Sign into the Google account to get data from Google
  // TODO: Implement sign using Facebook, Weibo in the future
  Future<bool> signInUsingGoogle() async {
    GoogleSignInAccount googleSignInAccount;

//    googleSignInAccount = await currentState.googleSignIn.signIn();
    if (!await currentState.googleSignIn.isSignedIn()) {
      // For login page
      print("if (!await currentState.googleSignIn.isSignedIn())");
      googleSignInAccount = await currentState.googleSignIn.signIn();
    } else {
      // For chat group list page
      print("if (await currentState.googleSignIn.isSignedIn())");
      googleSignInAccount = await currentState.googleSignIn.signInSilently(suppressErrors: false);
    }
    print("IMPORTANT: googleSignInAccount.id: " + googleSignInAccount.id);
    if (isObjectEmpty(googleSignInAccount)) {
      print("if (isObjectEmpty(googleSignInAccount))");
      Fluttertoast.showToast(msg: 'Google sign in canceled.', toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    print("Checkpoint 1");
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    AuthCredential credential =
        GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    currentState.firebaseUser = await currentState.firebaseAuth.signInWithCredential(credential);
    return true;
  }

  // Import User & Settings data from Firebase to app's state
  Future<bool> getUserFromFirebase() async {
    print("WholeAppBloc.dart getUserFromFirebase()");
    if (!isObjectEmpty(currentState.firebaseUser)) {
      print("if (!isObjectEmpty(currentState.firebaseUser))");
      // TODO:
      print("currentState.firebaseUser.uid: " + currentState.firebaseUser.uid);
      //TODO: Change to GoogleAccount.id
      final QuerySnapshot userResult =
          await Firestore.instance.collection('user').where('firebaseUserId', isEqualTo: currentState.firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> userDocument = userResult.documents;

      print("WholeAppBloc.dart userDocument.length: " + userDocument.length.toString());

      if (userDocument.length > 0) {
        print("if (userDocument.length > 0)");
        final QuerySnapshot settingsResult =
            await Firestore.instance.collection('settings').where('userId', isEqualTo: userDocument[0]['id'].toString()).getDocuments();
        final List<DocumentSnapshot> settingsDocument = settingsResult.documents;

        print("WholeAppBloc.dart settingsDocument.length: " + settingsDocument.length.toString());
        print("if (documents.length > 0)");
        print("documents[0]['firebaseUserId']: " + userDocument[0]['firebaseUserId']);
        print("currentState.firebaseUser.uid: " + currentState.firebaseUser.uid);

        print("WholeAppBloc.dart Validation");
        print("WholeAppBloc.dart userDocument[0].exists: " + userDocument[0].exists.toString());
        print("WholeAppBloc.dart userDocument[0]['firebaseUserId']: " + userDocument[0]['firebaseUserId']);
        print("WholeAppBloc.dart currentState.firebaseUser.uid: " + currentState.firebaseUser.uid);
        print("WholeAppBloc.dart settingsDocument[0].exists: " + settingsDocument[0].exists.toString());
        print("WholeAppBloc.dart userDocument[0]['id']: " + userDocument[0]['id']);
        print("WholeAppBloc.dart userDocument[0]['mobileNo']: " + userDocument[0]['mobileNo'].toString());

        // If both of them exists and settings.userId matches with user.id
        if ((userDocument[0].exists && userDocument[0]['firebaseUserId'] == currentState.firebaseUser.uid) &&
            (settingsDocument[0].exists && settingsDocument[0]["userId"].toString() == userDocument[0]['id'].toString())) {
          print("if (documents[0].exists && documents[0]['firebaseUserId'] == currentState.firebaseUser.uid)");
          // User
          currentState.userState.id = userDocument[0]['id'].toString();
          currentState.userState.displayName = userDocument[0]['displayName'].toString();
          currentState.userState.realName = userDocument[0]['realName'].toString();
          currentState.userState.firebaseUserId = userDocument[0]['firebaseUserId'].toString();
          currentState.userState.mobileNo = userDocument[0]['mobileNo'].toString();

          // Settings
          currentState.settingsState.id = settingsDocument[0]["id"].toString();
          currentState.settingsState.notification = settingsDocument[0]["notification"];
          currentState.settingsState.userId = settingsDocument[0]["userId"].toString();
          return true;
        } else {
          print("The Google account you signed in is not the same as the Google account registered with this phone number in the database");
          Fluttertoast.showToast(msg: 'Please use the correct Google account to sign in', toastLength: Toast.LENGTH_SHORT);
        }
      } else {
        print("if (documents.length == 0)");
      }
    }
    return false;
  }

  // TODO: Save to SQLite DB

  // Sign up a new User record in FireStore using GoogleAccount & FirebaseUser
  Future<bool> signUpInFirestore(UserSignUpEvent event) async {
    // Require user to connect to Google first in order to get some info from the user
    bool isSignedIn = await signInUsingGoogle();

    if (isSignedIn) {
      print("if(isSignedIn)");
      FirebaseUser firebaseUser = currentState.firebaseUser;

      User user = User(
          id: generateNewId().toString(),
          mobileNo: event.mobileNo,
          displayName: firebaseUser.displayName,
          firebaseUserId: firebaseUser.uid,
          realName: event.realName);

      Settings settings = Settings(id: generateNewId().toString(), notification: true, userId: user.id);

      if (!isObjectEmpty(firebaseUser)) {
        print("if (!isObjectEmpty(firebaseUser))");
        final QuerySnapshot duplicateGoogleAccountResult =
            await Firestore.instance.collection('user').where('firebaseUserId', isEqualTo: firebaseUser.uid).getDocuments();
        final List<DocumentSnapshot> duplicateGoogleAccountDocuments = duplicateGoogleAccountResult.documents;

        final QuerySnapshot duplicateMobileNoResult =
            await Firestore.instance.collection('user').where('firebaseUserId', isEqualTo: firebaseUser.uid).getDocuments();
        final List<DocumentSnapshot> duplicateMobileNoDocuments = duplicateMobileNoResult.documents;
        print("duplicateGoogleAccountDocuments.length: " + duplicateGoogleAccountDocuments.length.toString());
        print("duplicateMobileNoDocuments.length: " + duplicateMobileNoDocuments.length.toString());
        if (duplicateGoogleAccountDocuments.length == 0 && duplicateMobileNoDocuments.length == 0) {
          print("No same google account or mobile no found in the database.");
          print("user.id: " + user.id);
          print("user.mobileNo: " + user.mobileNo);
          print("user.displayName: " + user.displayName);
          print("user.firebaseUserId: " + user.firebaseUserId);
          print("user.realName: " + user.realName);

          Firestore.instance.collection('settings').document(settings.id).setData({
            'id': settings.id,
            'notification': settings.notification,
            'userId': settings.userId,
          });
          Firestore.instance.collection('user').document(user.id).setData({
            'id': user.id,
            'displayName': user.displayName,
            'realName': user.realName,
            'mobileNo': user.mobileNo,
            'firebaseUserId': user.firebaseUserId,
          });
          if (!isObjectEmpty(event)) {
            event.callback(true);
          }
          return true;
        } else {
          print("GOT SAME google account or mobile no found in the database.");
          Fluttertoast.showToast(msg: 'This mobile no has already been registered.', toastLength: Toast.LENGTH_SHORT);
          if (!isObjectEmpty(event)) {
            event.callback(false);
          }
          return false;
        }
      } else {
        print("if (isObjectEmpty(firebaseUser))");
      }
    }
    if (!isObjectEmpty(event)) {
      event.callback(false);
    }
    return false;
  }

  //  clear app's state and sign out
  signOut(UserSignOutEvent event) async {
    currentState.googleSignIn.signOut();
    currentState.userState = User();
    currentState.settingsState = Settings();
    currentState.firebaseUser = null;
    currentState.googleSignIn = null;
    currentState.conversationList = [];
    currentState.phoneContactList = [];
    currentState.multimediaList = [];
    currentState.unreadMessageList = [];
    currentState.userContactList = [];
    currentState.messageList = [];
  }

  getPhoneStorageContacts(GetPhoneStorageContactsEvent event) async {
    Map<PermissionGroup, PermissionStatus> permissions = await requestContactPermission();
    bool contactAccessGranted = false;
    permissions.forEach((PermissionGroup permissionGroup, PermissionStatus permissionStatus) {
      if (permissionGroup == PermissionGroup.contacts && permissionStatus == PermissionStatus.granted) {
        contactAccessGranted = true;
      }
    });
    if (contactAccessGranted) {
      print("contactAccessGranted!");
      Iterable<Contact> contacts = await ContactsService.getContacts();
      currentState.phoneContactList = contacts.toList(growable: true);
      currentState.phoneContactList.sort((a, b) => a.displayName.compareTo(b.displayName));

      // Dart way of removing duplicates. // https://stackoverflow.com/questions/12030613/how-to-delete-duplicates-in-a-dart-list-list-distinct
      currentState.phoneContactList = currentState.phoneContactList.toSet().toList();
      if (!isObjectEmpty(event)) {
        event.callback(true);
      }
    } else {
      print("contactAccessNotGranted?");
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
    }
  }

  Future<Map<PermissionGroup, PermissionStatus>> requestContactPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.contacts,
    ]);
    return permissions;
  }

  Future<Map<PermissionGroup, PermissionStatus>> checkPermissions(CheckPermissionEvent event) async {
    // Check statuses of all required permissions
    PermissionStatus contactPermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    PermissionStatus cameraPermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus storagePermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    PermissionStatus locationPermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    PermissionStatus microphonePermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);

    // Set PermissionGroups and PermissionStatuses
    Map<PermissionGroup, PermissionStatus> permissionResults = {};

    permissionResults[PermissionGroup.contacts] = contactPermission;
    permissionResults[PermissionGroup.camera] = cameraPermission;
    permissionResults[PermissionGroup.storage] = storagePermission;
    permissionResults[PermissionGroup.location] = locationPermission;
    permissionResults[PermissionGroup.microphone] = microphonePermission;
    if (!isObjectEmpty(event)) {
      event.callback(permissionResults);
    }
    return permissionResults;
  }

  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions({RequestPermissionsEvent event}) async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions(
        [PermissionGroup.contacts, PermissionGroup.camera, PermissionGroup.storage, PermissionGroup.location, PermissionGroup.microphone]);
    if (!isObjectEmpty(event)) {
      event.callback(permissions);
    }
    return permissions;
  }

  addConversation(AddConversationEvent event) async {
    print('addConversation()');

    // Check repetition
    bool conversationExist = false;

    currentState.conversationList.forEach((Conversation existingConversation) {
      if (existingConversation.id == event.conversation.id) {
        conversationExist = true;
      }
    });

    if (!conversationExist) {
      currentState.conversationList.add(event.conversation);
    }

    print("currentState.conversationList.length.toString(): " + currentState.conversationList.length.toString());
  }

  overrideUnreadMessageEvent(OverrideUnreadMessageEvent event) async {
    print('overrideUnreadMessageEvent()');
    print('event.unreadMessage.id: ' + event.unreadMessage.id);
    // Remove existing same id unreadMessage
    currentState.unreadMessageList.removeWhere((existingunreadMessage) => existingunreadMessage.id == event.unreadMessage.id);
    print('Checkpoint 1');
    // Read unreadMessage
    currentState.unreadMessageList.add(event.unreadMessage);
    print("currentState.unreadMessageList.length.toString(): " + currentState.unreadMessageList.length.toString());
    print('Checkpoint 2');
  }

  addMessage(AddMessageEvent event) async {
    print("event.message.id: " + event.message.id);
    // Check repetition
    bool messageExist = false;

    currentState.conversationList.forEach((Conversation existingMessage) {
      if (existingMessage.id == event.message.id) {
        messageExist = true;
      }
    });

    if (!messageExist) {
      currentState.messageList.add(event.message);
    }
    if (!isObjectEmpty(event)) {
      event.callback(event.message);
    }
  }

  addMultimedia(AddMultimediaEvent event) async {
    print("event.multimedia.id: " + event.multimedia.id);
    bool multimediaIdExist = false;

    // Check repetition
    currentState.multimediaList.forEach((Multimedia existingMultimedia) {
      if (existingMultimedia.id == event.multimedia.id) {
        multimediaIdExist = true;
      }
    });

    if (!multimediaIdExist) {
      currentState.multimediaList.add(event.multimedia);
    }
    if (!isObjectEmpty(event)) {
      event.callback(event.multimedia);
    }
  }

  addSettings(AddSettingsEvent event) async {
    print("event.message.id: " + event.settings.id);
    await Firestore.instance.collection('settings').document(event.settings.id).setData({
      'id': generateNewId().toString(), // Self generated Id
      'userId': event.settings.userId,
      'notification': event.settings.notification,
    });
    currentState.settingsState = event.settings;
    if (!isObjectEmpty(event)) {
      event.callback(event.settings);
    }
  }

  addUser(AddUserEvent event) async {
    print("event.message.id: " + event.user.id);
    currentState.userState = event.user;
    if (!isObjectEmpty(event)) {
      event.callback(event.user);
    }
  }

  addUserContact(AddUserContactEvent event) async {
    print("event.userContact.id: " + event.userContact.id);

    // Check repetition
    bool userContactExist = false;

    currentState.userContactList.forEach((UserContact existingUserContact) {
      if (existingUserContact.id == event.userContact.id) {
        userContactExist = true;
      }
    });

    if (!userContactExist) {
      currentState.userContactList.add(event.userContact);
    }
    if (!isObjectEmpty(event)) {
      event.callback(event.userContact);
    }
  }

  addContact(AddContactEvent event) async {
    print("event.userContact.displayName: " + event.contact.displayName);

    // Check repetition
    bool userContactExist = false;

    currentState.phoneContactList.forEach((Contact existingContact) {
      if (existingContact.displayName == event.contact.displayName) {
        userContactExist = true;
      }
    });

    if (!userContactExist) {
      currentState.phoneContactList.add(event.contact);
    }
    if (!isObjectEmpty(event)) {
      event.callback(event.contact);
    }
  }

  addFirebaseAuth(AddFirebaseAuthEvent event) async {
    print("event.firebaseAuth.app.name: " + event.firebaseAuth.app.name);
    currentState.firebaseAuth = event.firebaseAuth;
    if (!isObjectEmpty(event)) {
      event.callback(event.firebaseAuth);
    }
  }

  addGoogleSignIn(AddGoogleSignInEvent event) async {
    print("event.googleSignIn.currentUser.displayName: " + event.googleSignIn.currentUser.displayName);
    currentState.googleSignIn = event.googleSignIn;
    if (!isObjectEmpty(event)) {
      event.callback(event.googleSignIn);
    }
  }
}
