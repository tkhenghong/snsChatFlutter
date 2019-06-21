import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      signInUsingGoogle(event);
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
      signUpInFirestore(event.mobileNo);
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

  checkUserSignIn(CheckUserLoginEvent event) async {
    print('checkUserSignIn()');

    bool isSignedIn = false;
    GoogleSignInAccount googleSignInAccount;

    if (!await currentState.googleSignIn.isSignedIn()) {
      print("Not yet signed in. Go to login page...");
      isSignedIn = false;
      if (!isObjectEmpty(event)) {
        event.callback(isSignedIn);
      }
      return;
    } else {
      isSignedIn = true;
      if (!isObjectEmpty(event)) {
        event.callback(isSignedIn);
      }
//      googleSignInAccount = await currentState.googleSignIn.signInSilently(suppressErrors: false);
    }
  }

  Future<bool> checkUserSignedUp(CheckUserSignedUpEvent event) async {
    FirebaseUser firebaseUser = currentState.firebaseUser;
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .where('firebaseUserId',
            isEqualTo: currentState.userState.firebaseUserId)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    } else {
      currentState.userState.id = documents[0]['id'].toString();
      currentState.userState.userId = documents[0]['userId'].toString();
      currentState.userState.displayName =
          documents[0]['displayName'].toString();
      currentState.userState.realName = documents[0]['realName'].toString();
      currentState.userState.settingsId = documents[0]['settingsId'].toString();
      currentState.userState.mobileNo = documents[0]['mobileNo'].toString();
      if (!isObjectEmpty(event)) {
        event.callback(true);
      }
      return true;
    }
  }

  // Sign in using Google. If user hasn't signed up in the PocketChat, we will sign up on the spot.
  Future<User> signInUsingGoogle(UserSignInEvent event) async {
    bool isSignedIn = false;

    GoogleSignInAccount googleSignInAccount;
    if (!await currentState.googleSignIn.isSignedIn()) {
      print("Continue?");
      googleSignInAccount = await currentState.googleSignIn.signIn();
    } else {
      isSignedIn = true;
      googleSignInAccount =
          await currentState.googleSignIn.signInSilently(suppressErrors: false);
    }

    if(isObjectEmpty(googleSignInAccount)) {
      if (!isObjectEmpty(event)) {
        print("if (!isObjectEmpty(event))");
        event.callback(currentState.userState);
        return currentState.userState;
      }
    }

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    currentState.firebaseUser =
        await currentState.firebaseAuth.signInWithCredential(credential);

    // Check User Signed Up or not
    checkUserSignedUp(null).then((bool signedUp) {
      if (signedUp) {
        //  If user signed up means all good to go!
        print("Checkpoint 1");
        if (!isObjectEmpty(event)) {
          event.callback(currentState.userState);
        }
      } else {
        print("Checkpoint 2");
        signUpInFirestore(event.mobileNo).then((_) {
          print("Checkpoint 4");
          if (!isObjectEmpty(event)) {
            event.callback(currentState.userState);
          }
        });
      }
    });
    print("Checkpoint 3");

    return currentState.userState;
  }

  // TODO: Save to SQLite DB

  Future<void> signUpInFirestore(String mobileNo) async {
    FirebaseUser firebaseUser = currentState.firebaseUser;
    User user = User(
        id: generateNewId().toString(),
        mobileNo: mobileNo,
        // Add later
        settingsId: "",
        displayName: firebaseUser.displayName,
        firebaseUserId: firebaseUser.uid,
        realName: firebaseUser.displayName);
    Settings settings = Settings(
        id: generateNewId().toString(), notification: true, userId: user.id);

    user.settingsId = settings.id;

    if (!isObjectEmpty(firebaseUser)) {
      final QuerySnapshot result = await Firestore.instance
          .collection('user')
          .where('firebaseUserId', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        Firestore.instance
            .collection('user')
            .document(firebaseUser.uid)
            .setData({
          'id': generateNewId().toString(), // Self generated Id
          'displayName': firebaseUser.displayName,
          'realName': firebaseUser.displayName,
          'mobileNo': user.mobileNo,
          'settingsid': user.settingsId,
          'firebaseUserId': firebaseUser.uid,
        });
      } else {
        // Add user data from database to our app state
        print('documents.length.toString()' + documents.length.toString());
        if (documents[0].exists) {
          print('if (documents.length != 0)');
          currentState.userState.id = documents[0]['id'];
          currentState.userState.userId = documents[0]['userId'];
          currentState.userState.displayName = documents[0]['displayName'];
          currentState.userState.realName = documents[0]['realName'];
          currentState.userState.firebaseUserId =
              documents[0]['firebaseUserId'];
          currentState.userState.settingsId = documents[0]['settingsId'];
          currentState.userState.mobileNo = documents[0]['mobileNo'];
        }
      }
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
//      getPhoneStorageContacts(event);
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
