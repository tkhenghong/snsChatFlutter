import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
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
//    CheckUserLoginEvent
    print('State management center!');

    if (event is CheckUserLoginEvent) {
      checkUserSignIn(event);
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
      signUpInFirestore(event.user);
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
//     Read from Google Firestore
    if (currentState.userState.firebaseUser.uid.isEmpty) {
      print('Checkpoint 1');
      event.callback(false);
      return;
    } else {
      print('currentState.userState.firebaseUser.uid: ' + currentState.userState.firebaseUser.uid);
      print('currentState.userState.firebaseUser.displayName: ' + currentState.userState.firebaseUser.displayName);
    }
    print('Checkpoint 2');
    final QuerySnapshot result =
        await Firestore.instance.collection('user').where('userId', isEqualTo: currentState.userState.firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length == 0 ? event.callback(false) : event.callback(true);
  }

  signInUsingGoogle(UserSignInEvent event) async {
    print("signInUsingGoogle");
    // An average user use his/her Google account to sign in.
//    currentState.googleSignIn = new GoogleSignIn();
    GoogleSignInAccount googleSignInAccount;
    if(!await currentState.googleSignIn.isSignedIn()) {
      googleSignInAccount = await currentState.googleSignIn.signInSilently(suppressErrors: false);
    }
    // Authenticate the user in Google
    print("Got googleSignInAccount.");
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    print("Got googleSignInAuthentication.");
    // Create credentials
    AuthCredential credential =
        GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
    print("Got credential.");
    // Create the user in Firebase
    currentState.userState.firebaseUser = await currentState.firebaseAuth.signInWithCredential(credential);
    print("Saved firebaseUser.");
    // Find the user in Firebase, if got save it to current state
    FirebaseUser firebaseUser = currentState.userState.firebaseUser;
    final QuerySnapshot result = await Firestore.instance.collection('user').where('firebaseUser', isEqualTo: firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length > 0) {
      print('if (documents.length > 0)');
      // Add user data to database
      print('documents.length.toString(): ' + documents.length.toString());
      if (documents[0].exists) {
        print('if (documents[0].exists)');
        currentState.userState.id = documents[0]['id'].toString();
        currentState.userState.userId = documents[0]['userId'].toString();
        currentState.userState.displayName = documents[0]['displayName'].toString();
        currentState.userState.realName = documents[0]['realName'].toString();
//        currentState.userState.firebaseUser = documents[0]['firebaseUser'].toString(); // Remember firebaseuser is FirebaseUser object?
        currentState.userState.settingsId = documents[0]['settingsId'].toString();
        currentState.userState.mobileNo = documents[0]['mobileNo'].toString();
      }
    } else {
      print("No documents?");
      print('documents.length.toString()' + documents.length.toString());
    }


//    saveUsertoLocalDb();
    event.callback(); // Use callback method to signal UI change
  }

  // TODO: Save to SQLite DB later
//  saveUsertoLocalDb() async {
//    Find updater = new Find('user');
//    updater.eq('wadw', 'wda');
//    updater.
//  }

  signUpInFirestore(User user) async {
    FirebaseUser firebaseUser = currentState.userState.firebaseUser;

    if (firebaseUser != null) {
      print('if (firebaseUser != null)');
      // Sign in successful
      final QuerySnapshot result = await Firestore.instance.collection('user').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        Firestore.instance.collection('user').document(firebaseUser.uid).setData({
          'id': generateNewId().toString(), // Self generated Id
          'displayName': firebaseUser.displayName,
          'realName': firebaseUser.displayName,
          'userId': firebaseUser.uid,
          'mobileNo': user.mobileNo,
          'settingsid': user.settingsId,
          'firebaseUser': firebaseUser.uid,
//          'googleSignIn': googleSignInString,
//          'firebaseAuth': firebaseAuthString,
        });
        print('Sign Up done.');
      } else {
        print('if (documents.length != 0)');

        // Add user data to database
        print('documents.length.toString()' + documents.length.toString());
        if (documents[0].exists) {
          print('if (documents.length != 0)');
          currentState.userState.id = documents[0]['id'];
          currentState.userState.userId = documents[0]['userId'];
          currentState.userState.displayName = documents[0]['displayName'];
          currentState.userState.realName = documents[0]['realName'];
          currentState.userState.firebaseUser = documents[0]['firebaseUser'];
          currentState.userState.settingsId = documents[0]['settingsId'];
          currentState.userState.mobileNo = documents[0]['mobileNo'];
        }
      }
    } else {
      print('if (firebaseUser == null)');
    }
  }

  signOut(UserSignOutEvent event) async {
    currentState.googleSignIn.signOut();
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

      event.callback();
    } else {
      print("contactAccessNotGranted?");
      getPhoneStorageContacts(event);
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

    event.callback(permissionResults);
    return permissionResults;
  }

  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions({RequestPermissionsEvent event}) async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions(
        [PermissionGroup.contacts, PermissionGroup.camera, PermissionGroup.storage, PermissionGroup.location, PermissionGroup.microphone]);

    if (event.callback != null) {
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
    event.callback(event.message);
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

    event.callback(event.multimedia);
  }

  addSettings(AddSettingsEvent event) async {
    print("event.message.id: " + event.settings.id);
    currentState.settingsState = event.settings;
    event.callback(event.settings);
  }

  addUser(AddUserEvent event) async {
    print("event.message.id: " + event.user.id);
    currentState.userState = event.user;
    event.callback(event.user);
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

    event.callback(event.userContact);
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

    event.callback(event.contact);
  }

  addFirebaseAuth(AddFirebaseAuthEvent event) async {
    print("event.firebaseAuth.app.name: " + event.firebaseAuth.app.name);
    currentState.firebaseAuth = event.firebaseAuth;
    event.callback(event.firebaseAuth);
  }

  addGoogleSignIn(AddGoogleSignInEvent event) async {
    print("event.googleSignIn.currentUser.displayName: " + event.googleSignIn.currentUser.displayName);
    currentState.googleSignIn = event.googleSignIn;
    event.callback(event.googleSignIn);
  }
}
