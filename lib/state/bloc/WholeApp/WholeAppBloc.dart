import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';

class WholeAppBloc extends Bloc<WholeAppEvent, WholeAppState> {
  @override
  WholeAppState get initialState => WholeAppState.initial();

  @override
  Stream<WholeAppState> mapEventToState(WholeAppEvent event) async* {
    print('State management center!');
    if (event is UserSignInEvent) {
      signInUsingGoogle(event);
      yield currentState;
    } else if (event is UserSignOutEvent) {
      signOut(event);
      yield currentState;
    } else if (event is AddConversationEvent) {
      addConversation(event);
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
      signUpInFirestore();
      yield currentState;
    }
  }

  signInUsingGoogle(UserSignInEvent event) async {
    // An average user use his/her Google account to sign in.
    GoogleSignInAccount googleSignInAccount = await currentState.userState.googleSignIn.signIn();
    // Authenticate the user in Google

    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    // Create credentials
    AuthCredential credential =
        GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    // Create the user in Firebase
    currentState.userState.firebaseUser = await currentState.userState.firebaseAuth.signInWithCredential(credential);

    event.callback(); // Use callback method to signal UI change
  }

  signUpInFirestore() async {
    FirebaseUser firebaseUser = currentState.userState.firebaseUser;

    if (firebaseUser != null) {
      // Sign in successful
      final QuerySnapshot result = await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // User never signed up before
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({'nickname': firebaseUser.displayName, 'photoUrl': firebaseUser.photoUrl, 'id': firebaseUser.uid});
      }
    }
  }

  signOut(UserSignOutEvent event) async {
    currentState.userState.googleSignIn.signOut();
  }

  addConversation(AddConversationEvent event) async {
    currentState.conversationList.add(event.conversation);
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
}
