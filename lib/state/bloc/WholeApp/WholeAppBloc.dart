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

  Future<bool> checkUserSignIn(CheckUserLoginEvent event) async {
    print('checkUserSignIn()');

    bool isSignedIn = false;
    isSignedIn = await currentState.googleSignIn.isSignedIn();

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

  // Use contact mobile number to check this number is signed up or not
  Future<bool> checkUserSignedUp(CheckUserSignedUpEvent event) async {
    print("checkUserSignedUp()");
    bool isSignedUp = false;
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .where('mobileNo', isEqualTo: event.mobileNo)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    isSignedUp = documents.length > 0;
    print("isSignedUp: " + isSignedUp.toString());
    if (!isObjectEmpty(event)) {
      event.callback(isSignedUp);
    }
    return isSignedUp;
  }

  // Sign in using Google.
  // Will check user signed up or not. If not, will return false to the callback
  Future<bool> signIn(UserSignInEvent event) async {
    CheckUserSignedUpEvent checkUserSignedUpEvent = CheckUserSignedUpEvent(
        callback: (bool isSignedUp) {}, mobileNo: event.mobileNo);

    bool isSignedUp = await checkUserSignedUp(checkUserSignedUpEvent);

    print("CheckUserSignedUpEvent success");

    if (isSignedUp) {
      print("if (isSignedUp)");
      bool googleSignedIn = await signInUsingGoogle();
      if(!googleSignedIn) {
        if (!isObjectEmpty(event)) {
          event.callback(false);
        }
        return false;
      }

      bool getUserSuccessful = await getUserFromFirebase();
      print("getUserFromFirebase success");
      if (getUserSuccessful) {
        print("if (getUserSuccessful)");
        if (!isObjectEmpty(event)) {
          event.callback(true);
        }
        return true;
      }

      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    } else {
      print("if (!isSignedUp)");
      if (!isObjectEmpty(event)) {
        print("if (!isObjectEmpty(event))");
        event.callback(false);
      }
      return false;
    }
  }

  Future<bool> signInUsingGoogle() async {
    GoogleSignInAccount googleSignInAccount;
    if (!await currentState.googleSignIn.isSignedIn()) {
      print("if (!await currentState.googleSignIn.isSignedIn())");
      googleSignInAccount = await currentState.googleSignIn.signIn();
    } else {
      print("if (await currentState.googleSignIn.isSignedIn())");
      googleSignInAccount = await currentState.googleSignIn
          .signInSilently(suppressErrors: false);
    }

    if (isObjectEmpty(googleSignInAccount)) {
      print("if (isObjectEmpty(googleSignInAccount))");
      Fluttertoast.showToast(
          msg: 'Google sign in canceled.', toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    print("Checkpoint 1");
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    currentState.firebaseUser =
    await currentState.firebaseAuth.signInWithCredential(credential);
    return true;
  }

  Future<bool> getUserFromFirebase() async {
    if (!isObjectEmpty(currentState.firebaseUser)) {
      final QuerySnapshot result = await Firestore.instance
          .collection('user')
          .where('firebaseUserId', isEqualTo: currentState.firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length > 0) {
        print("if (documents.length > 0)");
        if (documents[0].exists &&
            documents[0]['firebaseUserId'] == currentState.firebaseUser.uid) {
          print(
              "if (documents[0].exists && documents[0]['firebaseUserId'] == currentState.firebaseUser.uid)");
          currentState.userState.id = documents[0]['id'];
          currentState.userState.displayName = documents[0]['displayName'];
          currentState.userState.realName = documents[0]['realName'];
          currentState.userState.firebaseUserId =
              documents[0]['firebaseUserId'];
          currentState.userState.mobileNo = documents[0]['mobileNo'];
          return true;
        }
      } else {
        print("if (documents.length == 0)");
      }
    }
    return false;
  }

  // TODO: Save to SQLite DB

  Future<bool> signUpInFirestore(UserSignUpEvent event) async {
    // Require user to connect to Google first in order to get some info from the user
    GoogleSignInAccount googleSignInAccount =
        await currentState.googleSignIn.signIn();
    if (isObjectEmpty(googleSignInAccount)) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
      return false;
    }
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    currentState.firebaseUser =
        await currentState.firebaseAuth.signInWithCredential(credential);

    FirebaseUser firebaseUser = currentState.firebaseUser;

    User user = User(
        id: generateNewId().toString(),
        mobileNo: event.mobileNo,
        displayName: firebaseUser.displayName,
        firebaseUserId: firebaseUser.uid,
        realName: event.realName);

    Settings settings = Settings(
        id: generateNewId().toString(), notification: true, userId: user.id);


    if (!isObjectEmpty(firebaseUser)) {
      print("if (!isObjectEmpty(firebaseUser))");
      final QuerySnapshot result = await Firestore.instance
          .collection('user')
          .where('firebaseUserId', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        print("if (documents.length == 0)");
        print("user.id: " + user.id);
        print("user.mobileNo: " + user.mobileNo);
        print("user.displayName: " + user.displayName);
        print("user.firebaseUserId: " + user.firebaseUserId);
        print("user.realName: " + user.realName);

        Firestore.instance
            .collection('settings')
            .document(settings.id)
            .setData({
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
      } else {
        print("if (documents.length > 0)");
        // Add user data from database to the app state
        print('documents.length.toString()' + documents.length.toString());
        if (documents[0].exists) {
          print('if (documents.length != 0)');
          currentState.userState.id = documents[0]['id'];
          currentState.userState.displayName = documents[0]['displayName'];
          currentState.userState.realName = documents[0]['realName'];
          currentState.userState.firebaseUserId =
              documents[0]['firebaseUserId'];
          currentState.userState.mobileNo = documents[0]['mobileNo'];
        }
      }
    } else {
      print("if (isObjectEmpty(firebaseUser))");
    }
  }

  signOut(UserSignOutEvent event) async {
    currentState.googleSignIn.signOut();
  }

  getPhoneStorageContacts(GetPhoneStorageContactsEvent event) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await requestContactPermission();
    bool contactAccessGranted = false;
    permissions.forEach(
        (PermissionGroup permissionGroup, PermissionStatus permissionStatus) {
      if (permissionGroup == PermissionGroup.contacts &&
          permissionStatus == PermissionStatus.granted) {
        contactAccessGranted = true;
      }
    });
    if (contactAccessGranted) {
      print("contactAccessGranted!");
      Iterable<Contact> contacts = await ContactsService.getContacts();
      currentState.phoneContactList = contacts.toList(growable: true);
      currentState.phoneContactList
          .sort((a, b) => a.displayName.compareTo(b.displayName));

      // Dart way of removing duplicates. // https://stackoverflow.com/questions/12030613/how-to-delete-duplicates-in-a-dart-list-list-distinct
      currentState.phoneContactList =
          currentState.phoneContactList.toSet().toList();
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

  Future<Map<PermissionGroup, PermissionStatus>>
      requestContactPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.contacts,
    ]);
    return permissions;
  }

  Future<Map<PermissionGroup, PermissionStatus>> checkPermissions(
      CheckPermissionEvent event) async {
    // Check statuses of all required permissions
    PermissionStatus contactPermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    PermissionStatus cameraPermission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus storagePermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    PermissionStatus locationPermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    PermissionStatus microphonePermission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);

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

  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions(
      {RequestPermissionsEvent event}) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.contacts,
      PermissionGroup.camera,
      PermissionGroup.storage,
      PermissionGroup.location,
      PermissionGroup.microphone
    ]);
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

    print("currentState.conversationList.length.toString(): " +
        currentState.conversationList.length.toString());
  }

  overrideUnreadMessageEvent(OverrideUnreadMessageEvent event) async {
    print('overrideUnreadMessageEvent()');
    print('event.unreadMessage.id: ' + event.unreadMessage.id);
    // Remove existing same id unreadMessage
    currentState.unreadMessageList.removeWhere((existingunreadMessage) =>
        existingunreadMessage.id == event.unreadMessage.id);
    print('Checkpoint 1');
    // Read unreadMessage
    currentState.unreadMessageList.add(event.unreadMessage);
    print("currentState.unreadMessageList.length.toString(): " +
        currentState.unreadMessageList.length.toString());
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
    await Firestore.instance
        .collection('settings')
        .document(event.settings.id)
        .setData({
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
    print("event.googleSignIn.currentUser.displayName: " +
        event.googleSignIn.currentUser.displayName);
    currentState.googleSignIn = event.googleSignIn;
    if (!isObjectEmpty(event)) {
      event.callback(event.googleSignIn);
    }
  }
}
