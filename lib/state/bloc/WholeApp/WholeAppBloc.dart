import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snschat_flutter/backend/rest/chat/ConversationGroupAPIService.dart';
import 'package:snschat_flutter/backend/rest/message/MessageAPIService.dart';
import 'package:snschat_flutter/backend/rest/multimedia/MultimediaAPIService.dart';
import 'package:snschat_flutter/backend/rest/settings/SettingsAPIService.dart';
import 'package:snschat_flutter/backend/rest/unreadMessage/UnreadMessageAPIService.dart';
import 'package:snschat_flutter/backend/rest/user/UserAPIService.dart';
import 'package:snschat_flutter/backend/rest/userContact/UserContactAPIService.dart';
import 'package:snschat_flutter/database/sembast/conversation_group/conversation_group.dart';
import 'package:snschat_flutter/database/sembast/message/message.dart';
import 'package:snschat_flutter/database/sembast/multimedia/multimedia.dart';
import 'package:snschat_flutter/database/sembast/settings/settings.dart';
import 'package:snschat_flutter/database/sembast/unread_message/unread_message.dart';
import 'package:snschat_flutter/database/sembast/user/user.dart';
import 'package:snschat_flutter/database/sembast/userContact/userContact.dart';

import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/chat/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/objects/websocket/WebSocketMessage.dart';
import 'package:snschat_flutter/service/FirebaseStorage/FirebaseStorageService.dart';
import 'package:snschat_flutter/service/image/ImageService.dart';
import 'package:snschat_flutter/service/permissions/PermissionService.dart';
import 'package:snschat_flutter/service/websocket/WebSocketService.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppState.dart';

class WholeAppBloc extends Bloc<WholeAppEvent, WholeAppState> {
  ConversationGroupAPIService conversationGroupAPIService = ConversationGroupAPIService();
  MessageAPIService messageAPIService = MessageAPIService();
  MultimediaAPIService multimediaAPIService = MultimediaAPIService();
  SettingsAPIService settingsAPIService = SettingsAPIService();
  UnreadMessageAPIService unreadMessageAPIService = UnreadMessageAPIService();
  UserAPIService userAPIService = UserAPIService();
  UserContactAPIService userContactAPIService = UserContactAPIService();

  ConversationDBService conversationGroupDBService = new ConversationDBService();
  MessageDBService messageDBService = MessageDBService();
  MultimediaDBService multimediaDBService = MultimediaDBService();
  SettingsDBService settingsDBService = SettingsDBService();
  UnreadMessageDBService unreadMessageDBService = UnreadMessageDBService();
  UserDBService userDBService = UserDBService();
  UserContactDBService userContactDBService = UserContactDBService();

  PermissionService permissionService = PermissionService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  ImageService imageService = ImageService();
  WebSocketService webSocketService = WebSocketService();

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
    } else if (event is LoadDatabaseToStateEvent) {
      loadDatabase(event);
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
    } else if (event is RequestAllPermissionsEvent) {
      requestAllRequiredPermissions(event: event);
      yield currentState;
    } else if (event is CheckPermissionEvent) {
      checkPermissions(event);
      yield currentState;
    } else if (event is UserSignUpEvent) {
      signUp(event);
      yield currentState;
    } else if (event is LoadUserPreviousDataEvent) {
      loadUserPreviousData(event);
      yield currentState;
    } else if (event is EditConversationGroupEvent) {
      editConversationGroup(event);
      yield currentState;
    } else if (event is EditMultimediaEvent) {
      editMultimedia(event);
      yield currentState;
    } else if (event is EditSettingsEvent) {
      editSettings(event);
      yield currentState;
    } else if (event is EditUnreadMessageEvent) {
      editUnreadMessage(event);
      yield currentState;
    } else if (event is EditUserEvent) {
      editUser(event);
      yield currentState;
    } else if (event is EditUserContactEvent) {
      editUserContact(event);
      yield currentState;
    } else if (event is AddConversationGroupToStateEvent) {
      addConversationToState(event);
      yield currentState;
    } else if (event is AddMessageToStateEvent) {
      addMessageToState(event);
      yield currentState;
    } else if (event is AddMultimediaToStateEvent) {
      addMultimediaToState(event);
      yield currentState;
    } else if (event is AddSettingsToStateEvent) {
      addSettingsToState(event);
      yield currentState;
    } else if (event is AddUserToStateEvent) {
      addUserToState(event);
      yield currentState;
    } else if (event is AddUserContactToStateEvent) {
      addUserContactToState(event);
      yield currentState;
    } else if (event is AddFirebaseAuthToStateEvent) {
      addFirebaseAuthToState(event);
      yield currentState;
    } else if (event is AddGoogleSignInToStateEvent) {
      addGoogleSignInToState(event);
      yield currentState;
    } else if (event is AddUnreadMessageToStateEvent) {
      addUnreadMessageToState(event);
      yield currentState;
    } else if (event is CreateConversationGroupEvent) {
      createConversationGroup(event);
      yield currentState;
    } else if (event is SendMessageEvent) {
      sendMessage(event);
      yield currentState;
    } else if (event is InitializeWebSocketServiceEvent) {
      listenToWebSocketMessage(event);
      yield currentState;
    } else if (event is SendWebSocketMessageEvent) {
      sendWebSocketMessage(event);
      yield currentState;
    } else if (event is ProcessMessageFromWebSocketEvent) {
      processMessageFromWebSocket(event);
      yield currentState;
    }
  }

  // Check user is signed into the google or not
  // Because if signed in Google SDK library is programmed to remember it every time you open your app
  // Developer doesn't have save those Google data by themselves
  Future<bool> checkUserSignIn(CheckUserLoginEvent event) async {
    print("checkUserSignIn()");
    bool isSignedIn = false;

    List<User> userList = await userDBService.getAllUsers();

    isSignedIn = await currentState.googleSignIn.isSignedIn() || userList == null || userList.length == 0;

    print("isSignedIn: " + isSignedIn.toString());
    if (!isObjectEmpty(event)) {
      event.callback(isSignedIn);
    }

    return isSignedIn;
  }

  // Use contact mobile number to check this number is signed up or not in the developer's Firebase
  Future<bool> checkUserSignedUp(CheckUserSignedUpEvent event) async {
    bool isSignedUp = false;
    User existingUser;
    bool googleSignInDone = await signInUsingGoogle();

    if (!googleSignInDone) {
      if (!isObjectEmpty(event)) {
        event.callback(isSignedUp);
      }
      return false;
    }

    if (!isStringEmpty(event.mobileNo)) {
      print("userAPIService.getUserByUsingMobileNo.");
      existingUser = await userAPIService.getUserByUsingMobileNo(event.mobileNo);
    } else {
      print("userAPIService.getUserByUsingGoogleAccountId.");
      existingUser = await userAPIService.getUserByUsingGoogleAccountId(currentState.googleSignIn.currentUser.id);
    }

    isSignedUp = existingUser != null;

    print("isSignedUp: " + isSignedUp.toString());

    if (!isObjectEmpty(event)) {
      event.callback(isSignedUp);
    }

    return isSignedUp;
  }

  Future<bool> loadDatabase(LoadDatabaseToStateEvent event) async {
    try {
      await currentState.googleSignIn.signInSilently(suppressErrors: false);
    } catch (e) {
      print("Error caught during login. Go to login page.");
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
      return false;
    }

    // Can be removed
    if (!(await currentState.googleSignIn.isSignedIn())) {
      // Google Account is not signed in, straight false
      Fluttertoast.showToast(msg: 'Google is not signed in. Please sign in first.', toastLength: Toast.LENGTH_LONG);
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    }

    User userFromDB = await userDBService.getUserByGoogleAccountId(currentState.googleSignIn.currentUser.id);
    if (isObjectEmpty(userFromDB)) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
      return false;
    }
    Settings settingsFromDB = await settingsDBService.getSettingsOfAUser(userFromDB.id);
    if (userFromDB == null && settingsFromDB == null) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
      return false;
    }

    List<ConversationGroup> conversationGroupListFromDB = await conversationGroupDBService.getAllConversationGroups();
    List<Message> messageListFromDB = await messageDBService.getAllMessages();
    List<Multimedia> multimediaListFromDB = await multimediaDBService.getAllMultimedia();
    List<UnreadMessage> unreadMessageListFromDB = await unreadMessageDBService.getAllUnreadMessage();
    List<UserContact> userContactListFromDB = await userContactDBService.getAllUserContacts();

    print("conversationGroupListFromDB.length: " + conversationGroupListFromDB.length.toString());
    print("messageListFromDB.length: " + messageListFromDB.length.toString());
    print("multimediaListFromDB.length: " + multimediaListFromDB.length.toString());
    print("unreadMessageListFromDB.length: " + unreadMessageListFromDB.length.toString());
    print("userContactListFromDB.length: " + userContactListFromDB.length.toString());

//    conversationGroupListFromDB.forEach((ConversationGroup conversationGroup) {
//      print("conversationGroup.id: " + conversationGroup.id);
//      print("conversationGroup.name: " + conversationGroup.name);
//    });
//
//    messageListFromDB.forEach((Message message) {
//      print("message.id: " + message.id);
//    });
//
//    multimediaListFromDB.forEach((Multimedia multimedia) {
//      print("multimedia: " + multimedia.toString());
//    });
//
//    unreadMessageListFromDB.forEach((UnreadMessage unreadMessage) {
//      print("unreadMessage.id: " + unreadMessage.id);
//      print("unreadMessage.date: " + formatTime(unreadMessage.date));
//    });
//
//    userContactListFromDB.forEach((UserContact userContact) {
//      print("userContact.id: " + userContact.id);
//      print("userContact.displayName: " + userContact.displayName);
//      print("userContact.mobileNo: " + userContact.mobileNo);
//    });

    addUserToState(AddUserToStateEvent(user: userFromDB, callback: (User user) {}));
    addSettingsToState(AddSettingsToStateEvent(settings: settingsFromDB, callback: (Settings settings) {}));
    currentState.conversationGroupList = conversationGroupListFromDB;
    currentState.messageList = messageListFromDB;
    currentState.multimediaList = multimediaListFromDB;
    currentState.unreadMessageList = unreadMessageListFromDB;
    currentState.userContactList = userContactListFromDB;

    if (!isObjectEmpty(event)) {
      event.callback(true);
    }
    print("All Data Loaded!");
    return true;
  }

  // Sign in using Google.
  // Will check user signed up or not first. If signed up, will read User data from Firebase
  // Output: The state will have GoogleAccount, FirebaseUser, User, Settings data
  Future<bool> signIn(UserSignInEvent event) async {
    bool googleSignedIn = await signInUsingGoogle();
    if (!googleSignedIn) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
      return false;
    }

    bool getUserAndSettingsSuccessful = await getUserAndSettings();
    if (getUserAndSettingsSuccessful) {
      // In case of Sign in from login page, check mobile no with state's mobile no got from User's current state
      if (!isStringEmpty(event.mobileNo)) {
        if (currentState.userState.mobileNo.toString() != event.mobileNo.toString()) {
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
  }

  // Sign into the Google account to get data from Google
  // TODO: Implement sign using Facebook, Weibo in the future
  Future<bool> signInUsingGoogle() async {
    GoogleSignInAccount googleSignInAccount;

    if (!await currentState.googleSignIn.isSignedIn()) {
      // For login page
      googleSignInAccount = await currentState.googleSignIn.signIn();
    } else {
      // For chat group list page
      googleSignInAccount = await currentState.googleSignIn.signInSilently(suppressErrors: false);
    }

    if (isObjectEmpty(googleSignInAccount)) {
      Fluttertoast.showToast(msg: 'Google sign in canceled.', toastLength: Toast.LENGTH_SHORT);
      return false;
    }

    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    AuthCredential credential =
        GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

    AuthResult authResult = await currentState.firebaseAuth.signInWithCredential(credential);
    currentState.firebaseUser = authResult.user;

    return true;
  }

  // Import User & Settings data from REST to app's state
  Future<bool> getUserAndSettings() async {
    if (isObjectEmpty(currentState.firebaseUser)) {
      return false;
    }

    User userFromServer = await userAPIService.getUserByUsingGoogleAccountId(currentState.googleSignIn.currentUser.id);
    if (userFromServer == null) {
      return false;
    }

    Settings settingsFromServer = await settingsAPIService.getSettingsOfAUser(userFromServer.id);
    if (settingsFromServer == null) {
      return false;
    }

    if (userFromServer.id == settingsFromServer.userId) {
      currentState.userState = userFromServer;
      currentState.settingsState = settingsFromServer;

      bool userSaved = await userDBService.addUser(userFromServer);
      bool settingsSaved = await settingsDBService.addSettings(settingsFromServer);

      return userSaved && settingsSaved;
    } else {
      Fluttertoast.showToast(msg: 'Please use the correct Google account to sign in', toastLength: Toast.LENGTH_SHORT);
    }

    return true;
  }

  // Sign up a new User record in FireStore using GoogleAccount & FirebaseUser
  Future<bool> signUp(UserSignUpEvent event) async {
    bool isSignedUp = await checkUserSignedUp(CheckUserSignedUpEvent(callback: (bool isSignedUp) {}, mobileNo: event.mobileNo));

    if (isSignedUp) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    }
    FirebaseUser firebaseUser = currentState.firebaseUser;

    if (!isObjectEmpty(firebaseUser)) {
      GoogleSignInAccount googleSignInAccount = currentState.googleSignIn.currentUser;
      User user = User(
          id: null,
          mobileNo: event.mobileNo,
          displayName: firebaseUser.displayName,
          googleAccountId: googleSignInAccount.id,
          realName: event.realName);

      Settings settings = Settings(id: null, notification: true, userId: user.id);
      Multimedia multimedia = Multimedia(
          id: null,
          conversationId: null,
          imageDataId: null,
          imageFileId: null,
          localFullFileUrl: null,
          localThumbnailUrl: null,
          remoteFullFileUrl: null,
          remoteThumbnailUrl: null,
          messageId: null,
          userContactId: null);
      UserContact userContact = UserContact(
        id: null,
        multimediaId: null,
        mobileNo: event.mobileNo,
        displayName: firebaseUser.displayName,
        realName: event.realName,
        lastSeenDate: DateTime.now().millisecondsSinceEpoch,
        block: false,
        userIds: [], // Add userId into it after User is Created
      );
      bool created = await createUser(user, settings, multimedia, userContact);

      if (!isObjectEmpty(event)) {
        event.callback(created);
      }

      return created;
    }
    Fluttertoast.showToast(
        msg: 'Registered Mobile No./Google Account. Please use another Mobile No./Google Account to register.',
        toastLength: Toast.LENGTH_SHORT);

    if (!isObjectEmpty(event)) {
      event.callback(false);
    }

    return false;
  }

  Future<bool> createUser(User user, Settings settings, Multimedia multimedia, UserContact userContact) async {
    // REST API --> Local DB

    Multimedia multimediaFromServer = await multimediaAPIService.addMultimedia(multimedia);
    if (multimediaFromServer == null) {
      return false;
    }

//    multimedia.id = user.multimediaId = multimediaFromServer.id;
    multimedia.id = multimediaFromServer.id;

    bool multimediaSaved = await multimediaDBService.addMultimedia(multimedia);
    if (!multimediaSaved) {
      return false;
    }

    User userFromServer = await userAPIService.addUser(user);
    if (userFromServer == null) {
      return false;
    }

    multimedia.userId = settings.userId = user.id = userFromServer.id;

    // Update the multimedia after the User is created
    multimediaAPIService.editMultimedia(multimedia);
    multimediaDBService.editMultimedia(multimedia);

    userContact.userIds.add(user.id);
    userContact.multimediaId = multimedia.id;

    bool userSaved = await userDBService.addUser(user);
    if (!userSaved) {
      return false;
    }

    UserContact userContactFromServer = await userContactAPIService.addUserContact(userContact);
    if (userContactFromServer == null) {
      return false;
    }

    userContact.id = userContactFromServer.id;

    bool userContactSaved = await userContactDBService.addUserContact(userContact);
    if (!userContactSaved) {
      return false;
    }

    Settings settingsFromServer = await settingsAPIService.addSettings(settings);
    if (settingsFromServer == null) {
      return false;
    }

    settings.id = settingsFromServer.id;

    bool settingsSaved = await settingsDBService.addSettings(settings);
    if (!settingsSaved) {
      return false;
    }

    return true;
  }

  //  clear app's state and sign out
  signOut(UserSignOutEvent event) async {
    currentState.firebaseAuth.signOut();
    currentState.googleSignIn.disconnect();
    currentState.googleSignIn.signOut();
    currentState.userState = User();
    currentState.settingsState = Settings();
    currentState.firebaseUser = null;
    currentState.googleSignIn = new GoogleSignIn();
    currentState.conversationGroupList = [];
    currentState.phoneContactList = [];
    currentState.multimediaList = [];
    currentState.unreadMessageList = [];
    currentState.userContactList = [];
    currentState.messageList = [];
  }

  getPhoneStorageContacts(GetPhoneStorageContactsEvent event) async {
    bool contactAccessGranted = await permissionService.requestContactPermission();
    if (contactAccessGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      currentState.phoneContactList = contacts.toList(growable: true);
      currentState.phoneContactList.sort((a, b) => a.displayName.compareTo(b.displayName));

      // Dart way of removing duplicates. // https://stackoverflow.com/questions/12030613/how-to-delete-duplicates-in-a-dart-list-list-distinct
      currentState.phoneContactList = currentState.phoneContactList.toList();
      if (!isObjectEmpty(event)) {
        event.callback(true);
      }
    } else {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
    }
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

  Future<bool> loadUserPreviousData(LoadUserPreviousDataEvent event) async {
    print("LoadUserPreviousDataEvent");
    bool loadConversationsDone = await loadConversationsOfTheUser();
    bool loadUnreadMessageDone = await loadUnreadMessageOfTheUser();
    bool loadUserContactsDone = await getUserContactsOfTheUser();
    bool loadMultimediaDone = await loadMultimediaOfTheUser();

//    print("loadConversationsDone: " + loadConversationsDone.toString());
//    print("loadUnreadMessageDone: " + loadUnreadMessageDone.toString());
//    print("loadUserContactsDone: " + loadUserContactsDone.toString());
//    print("loadMultimediaDone: " + loadMultimediaDone.toString());

    bool allDone = loadConversationsDone && loadUnreadMessageDone && loadUserContactsDone && loadMultimediaDone;

    if (!isObjectEmpty(event)) {
      event.callback(allDone);
    }

    return allDone;
  }

  // At this point the currentState already has conversationGroupList from DB
  Future<bool> loadConversationsOfTheUser() async {
    List<ConversationGroup> conversationGroupListFromServer =
        await conversationGroupAPIService.getConversationGroupsForUserByMobileNo(currentState.userState.mobileNo);

    if (!isObjectEmpty(conversationGroupListFromServer) && conversationGroupListFromServer.length > 0) {
      // Update the current info of the conversationGroup to latest information
      conversationGroupListFromServer.forEach((conversationGroupFromServer) {
        // TODO: Review the performance of this loop
        bool conversationGroupExist = currentState.conversationGroupList
            .contains((ConversationGroup conversationGroupFromDB) => conversationGroupFromDB.id == conversationGroupFromServer.id);

        if (conversationGroupExist) {
          conversationGroupDBService.editConversationGroup(conversationGroupFromServer);
        } else {
          conversationGroupDBService.addConversationGroup(conversationGroupFromServer);
        }

        addConversationToState(AddConversationGroupToStateEvent(
            callback: (ConversationGroup conversationGroup) {}, conversationGroup: conversationGroupFromServer));
      });
    }

    return true;
  }

  // Get:
  // getMultimediaOfAUser
  // getMultimediaOfAConversation (Means you already covered the message's multimedia part)
  // getMultimediaOfAUserContact
  Future<bool> loadMultimediaOfTheUser() async {
    List<Multimedia> multimediaList = [];

    // TODO: Should get a list of multimedia from User, UserContact, ConversationGroup and Message (A lot of work from backend)
    Multimedia multimediaFromServer = await multimediaAPIService.getMultimediaOfAUser(currentState.userState.id);

    if (isObjectEmpty(multimediaFromServer)) {
      return false;
    }

    multimediaList.add(multimediaFromServer);

    // Get multimedia of the conversationGroups
    if (!isObjectEmpty(currentState.conversationGroupList) && currentState.conversationGroupList.length > 0) {
      for (ConversationGroup conversationGroup in currentState.conversationGroupList) {
        List<Multimedia> multimediaListFromServer = await multimediaAPIService.getAllMultimediaOfAConversationGroup(conversationGroup.id);

        if (!isObjectEmpty(multimediaListFromServer) && multimediaListFromServer.length > 0) {
          multimediaListFromServer.forEach((multimediaFromServer2) {
            multimediaList.add(multimediaFromServer2);
          });
        }
      }
    }

    // Get multimedia of the UserContacts that this user own
    if (!isObjectEmpty(currentState.userContactList) && currentState.userContactList.length > 0) {
      for (UserContact userContact in currentState.userContactList) {
        Multimedia multimediaFromServer3 = await multimediaAPIService.getMultimediaOfAUserContact(userContact.id);

        if (!isObjectEmpty(multimediaFromServer3)) {
          multimediaList.add(multimediaFromServer3);
        }
      }
    }

    if (!isObjectEmpty(multimediaList) && multimediaList.length > 0) {
      multimediaList.forEach((Multimedia multimediaFromServer) {
        multimediaDBService.addMultimedia(multimediaFromServer);

        dispatch(AddMultimediaToStateEvent(multimedia: multimediaFromServer, callback: (Multimedia multimedia) {}));
      });
    }

    return true;
  }

  Future<bool> getUserContactsOfTheUser() async {
    List<UserContact> userContactListFromServer = await userContactAPIService.getUserContactsByUserId(currentState.userState.id);
    if (userContactListFromServer != null && userContactListFromServer.length > 0) {
      // Update the current info of the conversationGroup to latest information
      userContactListFromServer.forEach((userContactFromServer) {
        // TODO: Review the performance of this loop
        bool userContactExist = currentState.conversationGroupList
            .contains((UserContact userContactFromDB) => userContactFromDB.id == userContactFromServer.id);
        if (userContactExist) {
          userContactDBService.editUserContact(userContactFromServer);
        } else {
          userContactDBService.addUserContact(userContactFromServer);
        }
        dispatch(AddUserContactToStateEvent(callback: (UserContact userContact) {}, userContact: userContactFromServer));
      });

      return true;
    }

    return false;
  }

  Future<bool> loadUnreadMessageOfTheUser() async {
    List<UnreadMessage> unreadMessageListFromServer = await unreadMessageAPIService.getUnreadMessagesOfAUser(currentState.userState.id);

    if (unreadMessageListFromServer != null && unreadMessageListFromServer.length > 0) {
      // Update the current info of the conversationGroup to latest information
      unreadMessageListFromServer.forEach((unreadMessageFromServer) {
        // TODO: Review the performance of this loop
        bool unreadMessageExist = currentState.unreadMessageList
            .contains((UnreadMessage unreadMessageFromDB) => unreadMessageFromDB.id == unreadMessageFromServer.id);
        if (unreadMessageExist) {
          unreadMessageDBService.editUnreadMessage(unreadMessageFromServer);
        } else {
          unreadMessageDBService.addUnreadMessage(unreadMessageFromServer);
        }
        dispatch(AddUnreadMessageToStateEvent(callback: (UnreadMessage unreadMessage) {}, unreadMessage: unreadMessageFromServer));
      });
    }

    return true;
  }

  // TODO: Don't need this??
  Future<bool> getSettingsOfTheUserFromServer() async {
    // Assume you have signed in and loaded DB
    Settings settingsFromServer = await settingsAPIService.getSettingsOfAUser(currentState.userState.id);
    if (isObjectEmpty(settingsFromServer)) {
      return false;
    }
    bool settingsExist = !isObjectEmpty(currentState.settingsState);
    if (settingsExist) {
      settingsDBService.editSettings(settingsFromServer);
    } else {
      settingsDBService.addSettings(settingsFromServer);
    }

    dispatch(AddSettingsToStateEvent(callback: (Settings settings) {}, settings: settingsFromServer));

    return true;
  }

  Future<Map<PermissionGroup, PermissionStatus>> requestAllRequiredPermissions({RequestAllPermissionsEvent event}) async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions(
        [PermissionGroup.contacts, PermissionGroup.camera, PermissionGroup.storage, PermissionGroup.location, PermissionGroup.microphone]);
    if (!isObjectEmpty(event)) {
      event.callback(permissions);
    }
    return permissions;
  }

  // TODO: Allow conversationGroup to be created first, other components have to update the conversationGroup from now on
  // TODO: To allow faster loading
  Future<ConversationGroup> createConversationGroup(CreateConversationGroupEvent event) async {
    print("CreateConversationGroupEvent in BLOC");
    // Create Single Group successfully (1 ConversationGroup, 2 UserContact, 1 UnreadMessage, 1 Multimedia)
    // Upload conversation to REST API and Local DB

    UserContact yourOwnUserContact = UserContact(
      id: null,
      // userIds: Which User owns this UserContact
      userIds: [currentState.userState.id],
      displayName: currentState.userState.displayName,
      realName: currentState.userState.realName,
      block: false,
      lastSeenDate: new DateTime.now().millisecondsSinceEpoch,
      // make unknown time, let server decide
      mobileNo: currentState.userState.mobileNo,
    );
    List<UserContact> userContactList = [];

    //Add yourself first
    userContactList.add(yourOwnUserContact);
    event.contactList.forEach((contact) {
      List<String> primaryNo = [];
      if (contact.phones.length > 0) {
        contact.phones.forEach((phoneNo) {
          primaryNo.add(phoneNo.value);
        });
      } else {
        // No phone number and the display name is the phone number itself
        // Reason: No contact.phones when the mobile number doesn't have a name on it
        String mobileNo = contact.displayName.replaceAll("TO\\s", "");
        print("mobileNo with whitespaces removed: " + mobileNo);
        primaryNo.add(mobileNo);
      }

      UserContact userContact = UserContact(
        id: null,
        userIds: [currentState.userState.id],
        // So this contact number is mine. Later send it to backend and merge with other UserContact who got the same number
        displayName: contact.displayName,
        realName: contact.displayName,
        block: false,
        lastSeenDate: new DateTime.now().millisecondsSinceEpoch,
      );

      userContact.mobileNo = primaryNo.length == 0 ? "" : primaryNo[0];

      // If got Malaysia number
      if (primaryNo[0].contains("+60")) {
        print("If Malaysian Number: ");
        String trimmedString = primaryNo[0].substring(3);
        print("trimmedString: " + trimmedString);
      }

      userContactList.add(userContact);
    });

    // 1. Upload UserContactList
    // Note: Backend already helped you to check any duplicates of the same UserContact
    List<UserContact> newUserContactList = await addUserContactList(userContactList);
    print("Uploaded and saved uploadUserContactList to REST, DB and State.");

    // event.contactList doesn't include yourself, so newUserContactList.length - 1 OR Any UserContact is not added into the list (means not uploaded successfully)
    if ((event.contactList.length != newUserContactList.length - 1) || newUserContactList.length == 0) {
      // That means some UseContact are not uploaded into the REST
      return null;
    }

    // Replace the list with no Id with the one with Ids
    userContactList = newUserContactList;

    // Give the list of UserContactIds to memberIds of ConversationGroup
    event.conversationGroup.memberIds = userContactList.map((newUserContact) => newUserContact.id).toList();

    // Add your own userContact's ID as admin by find the one that has the same mobile number in the userContactList
    if (event.conversationGroup.type == "Personal") {
      event.conversationGroup.adminMemberIds = userContactList.map((UserContact userContact) => userContact.id).toList();
    } else {
      event.conversationGroup.adminMemberIds.add(userContactList
          .firstWhere((UserContact newUserContact) => newUserContact.mobileNo == currentState.userState.mobileNo, orElse: () => null)
          .id);
    }

    // 2. Upload ConversationGroup
    ConversationGroup newConversationGroup = await addConversationGroup(event.conversationGroup);
    print("Uploaded and saved conversationGroup to REST, DB.");
    if (newConversationGroup == null) {
      return null;
    }

    event.conversationGroup = newConversationGroup;

    print("newConversationGroup.id: " + newConversationGroup.id.toString());
    dispatch(AddConversationGroupToStateEvent(
        conversationGroup: newConversationGroup,
        callback: (ConversationGroup conversationGroup) {
          // Send success here to prevent the user waiting too long (ConversationGroup with UnreadMessage)
          if (!isObjectEmpty(event)) {
            event.callback(conversationGroup);
          }
        }));

    // 3. Upload Unread Message
    UnreadMessage unreadMessage = UnreadMessage(
      id: null,
      conversationId: newConversationGroup.id,
      count: 0,
      date: DateTime.now().millisecondsSinceEpoch,
      lastMessage: "",
      userId: newConversationGroup.creatorUserId,
    );
    UnreadMessage newUnreadMessage = await addUnreadMessage(unreadMessage);
    print("Uploaded and saved UnreadMessage to REST, DB.");
    if (newUnreadMessage == null) {
      return null;
    }

    event.multimedia.conversationId = newConversationGroup.id;

    // 4. Upload Group Multimedia
    // Create thumbnail before upload
    File thumbnailImageFile;
    if (!isStringEmpty(event.multimedia.localFullFileUrl)) {
      thumbnailImageFile = await imageService.getImageThumbnail(event.imageFile);
    }

    if (!isObjectEmpty(thumbnailImageFile)) {
      event.multimedia.localThumbnailUrl = thumbnailImageFile.path;
    }

    Multimedia newMultimedia = await addMultimedia(event.multimedia);
    print("Uploaded and saved ConversationGroup Multimedia to REST, DB.");
    if (newMultimedia == null) {
      return null;
    }

    if (!isStringEmpty(newMultimedia.localFullFileUrl)) {
      // If there's a local file, upload the file and update the multimedia in API, DB and state
      updateMultimediaContent(newMultimedia, newConversationGroup);
    }

    // No matter what situation, you need to show the group photo to the user first(load faster)
    dispatch(AddMultimediaToStateEvent(multimedia: newMultimedia, callback: (Multimedia multimedia) {}));

    return newConversationGroup;
  }

  Future<Message> sendMessage(SendMessageEvent event) async {
    Message newMessage = await addMessage(event.message);
    if (isObjectEmpty(newMessage)) {
      if (!isObjectEmpty(event)) {
        event.callback(null);
      }
      return null;
    }

    bool multimediaExist = !isObjectEmpty(event.multimedia);
    Multimedia multimedia;

    if (multimediaExist) {
      event.multimedia.messageId = newMessage.id;
      multimedia = await addMultimedia(event.multimedia);
    }

    // If multimediaExist(When you pass in the object) but multimedia is empty (due to upload to OSS failed/save object to API/DB failed)
    if ((multimediaExist && isObjectEmpty(multimedia))) {
      if (!isObjectEmpty(event)) {
        event.callback(null);
      }
      return null;
    }

    // Do this instead of triggering method directly will make the Bloc to resend the signals to listeners
    dispatch(AddMessageToStateEvent(message: newMessage, callback: (Message message) {}));

    if (!isObjectEmpty(event)) {
      event.callback(newMessage);
    }
    return newMessage;
  }

  // Upload the list of UserContact to REST API (checked duplicates at there), get them back, and save all of them to DB and State
  Future<List<UserContact>> addUserContactList(List<UserContact> userContactList) async {
    List<UserContact> newUserContactList = [];
    for (UserContact userContact in userContactList) {
      UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
      if (newUserContact != null) {
        UserContact existingUserContact = await userContactAPIService.getUserContact(newUserContact.id);
        if (existingUserContact != null) {
          // Weakness: No error handling if UserContact save to DB fails
          userContactDBService.addUserContact(existingUserContact);
          dispatch(AddUserContactToStateEvent(userContact: existingUserContact, callback: (UserContact userContact) {}));
          newUserContactList.add(existingUserContact);
        }
      }
    }

    return newUserContactList;
  }

  Future<ConversationGroup> addConversationGroup(ConversationGroup conversationGroup) async {
    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(conversationGroup);

    if (isObjectEmpty(newConversationGroup)) {
      return null;
    }

    bool conversationGroupSaved = await conversationGroupDBService.addConversationGroup(newConversationGroup);

    if (!conversationGroupSaved) {
      return null;
    }

    dispatch(AddConversationGroupToStateEvent(conversationGroup: newConversationGroup, callback: (ConversationGroup conversationGroup) {}));

    return newConversationGroup;
  }

  Future<ConversationGroup> editConversationGroup(EditConversationGroupEvent event) async {
    bool updatedInREST = await conversationGroupAPIService.editConversationGroup(event.conversationGroup);

    if (!updatedInREST) {
      return null;
    }
    bool conversationGroupSaved = await conversationGroupDBService.editConversationGroup(event.conversationGroup);

    if (!conversationGroupSaved) {
      return null;
    }

    dispatch(
        AddConversationGroupToStateEvent(conversationGroup: event.conversationGroup, callback: (ConversationGroup conversationGroup) {}));

    if (!isObjectEmpty(event)) {
      event.callback(event.conversationGroup);
    }

    return event.conversationGroup;
  }

  Future<UnreadMessage> addUnreadMessage(UnreadMessage unreadMessage) async {
    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);

    if (isObjectEmpty(newUnreadMessage)) {
      return null;
    }

    bool unreadMessageSaved = await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

    if (!unreadMessageSaved) {
      return null;
    }

    dispatch(AddUnreadMessageToStateEvent(unreadMessage: newUnreadMessage, callback: (UnreadMessage unreadMessage) {}));

    return newUnreadMessage;
  }

  Future<Multimedia> addMultimedia(Multimedia multimedia) async {
    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(multimedia);

    if (isObjectEmpty(newMultimedia)) {
      return null;
    }

    bool conversationGroupMultimediaSaved = await multimediaDBService.addMultimedia(newMultimedia);

    if (!conversationGroupMultimediaSaved) {
      return null;
    }

    dispatch(AddMultimediaToStateEvent(multimedia: newMultimedia, callback: (Multimedia multimedia) {}));

    return newMultimedia;
  }

  Future<Multimedia> editMultimedia(EditMultimediaEvent event) async {
    print("editMultimedia");
    if (event.updateInREST) {
      bool updatedInREST = await multimediaAPIService.editMultimedia(event.multimedia);
      print("updatedInREST: " + updatedInREST.toString());
      if (!updatedInREST) {
        return null;
      }
    }

    if (event.updateInDB) {
      bool multimediaSaved = await multimediaDBService.editMultimedia(event.multimedia);
      print("multimediaSaved: " + multimediaSaved.toString());
      if (!multimediaSaved) {
        return null;
      }
    }

    if (event.updateInState) {
      dispatch(AddMultimediaToStateEvent(multimedia: event.multimedia, callback: (Multimedia multimedia) {}));
    }

    if (!isObjectEmpty(event)) {
      event.callback(event.multimedia);
    }

    return event.multimedia;
  }

  Future<Settings> editSettings(EditSettingsEvent event) async {
    bool updatedInREST = await settingsAPIService.editSettings(event.settings);

    if (!updatedInREST) {
      return null;
    }

    bool settingsSaved = await settingsDBService.editSettings(event.settings);

    if (!settingsSaved) {
      return null;
    }

    dispatch(AddSettingsToStateEvent(settings: event.settings, callback: (Settings settings) {}));

    if (!isObjectEmpty(event)) {
      event.callback(event.settings);
    }

    return event.settings;
  }

  Future<UnreadMessage> editUnreadMessage(EditUnreadMessageEvent event) async {
    bool updatedInREST = await unreadMessageAPIService.editUnreadMessage(event.unreadMessage);

    if (!updatedInREST) {
      return null;
    }

    bool unreadMessageSaved = await unreadMessageDBService.editUnreadMessage(event.unreadMessage);

    if (!unreadMessageSaved) {
      return null;
    }

    dispatch(AddUnreadMessageToStateEvent(unreadMessage: event.unreadMessage, callback: (UnreadMessage unreadMessage) {}));

    if (!isObjectEmpty(event)) {
      event.callback(event.unreadMessage);
    }

    return event.unreadMessage;
  }

  Future<User> editUser(EditUserEvent event) async {
    bool updatedInREST = await userAPIService.editUser(event.user);

    if (!updatedInREST) {
      return null;
    }

    bool userSaved = await userDBService.editUser(event.user);

    if (!userSaved) {
      return null;
    }

    dispatch(AddUserToStateEvent(user: event.user, callback: (User user) {}));

    if (!isObjectEmpty(event)) {
      event.callback(event.user);
    }

    return event.user;
  }

  Future<UserContact> editUserContact(EditUserContactEvent event) async {
    bool updatedInREST = await userContactAPIService.editUserContact(event.userContact);

    if (!updatedInREST) {
      return null;
    }

    bool userContactSaved = await userContactDBService.editUserContact(event.userContact);

    if (!userContactSaved) {
      return null;
    }

    dispatch(AddUserContactToStateEvent(userContact: event.userContact, callback: (UserContact userContact) {}));

    if (!isObjectEmpty(event)) {
      event.callback(event.userContact);
    }

    return event.userContact;
  }

  Future<bool> updateMultimediaContent(Multimedia multimedia, ConversationGroup conversationGroup) async {
    print("updateMultimediaContent()");
    String remoteUrl = await firebaseStorageService.uploadFile(multimedia.localFullFileUrl, conversationGroup.type, conversationGroup.id);
    print("remoteUrl: " + remoteUrl.toString());
    String remoteThumbnailUrl =
        await firebaseStorageService.uploadFile(multimedia.localThumbnailUrl, conversationGroup.type, conversationGroup.id);
    print("remoteThumbnailUrl: " + remoteThumbnailUrl.toString());
    if (!isStringEmpty(remoteUrl)) {
      multimedia.remoteFullFileUrl = remoteUrl;
      multimedia.remoteThumbnailUrl = remoteThumbnailUrl;

      print("Updating multimedia...");
      // Special: straight call editMultimedia function instead of dispatch
      Multimedia editedMultimedia = await editMultimedia(EditMultimediaEvent(
          multimedia: multimedia, updateInREST: true, updateInDB: true, updateInState: true, callback: (Multimedia multimedia) {}));

      if (isObjectEmpty(editedMultimedia)) {
        return false;
      }

      return true;
    }

    return false;
  }

  Future<Message> addMessage(Message message) async {
    // TODO: Save message to DB & State first, then API (so that you can retry the message if it's determined not sent)
    Message newMessage = await messageAPIService.addMessage(message);

    if (isObjectEmpty(newMessage)) {
      return null;
    }

    bool messageSaved = await messageDBService.addMessage(newMessage);

    if (!messageSaved) {
      return null;
    }

    dispatch(AddMessageToStateEvent(message: newMessage, callback: (Message message) {}));

    return newMessage;
  }

  // No edit message

  Future<ConversationGroup> addConversationToState(AddConversationGroupToStateEvent event) async {
    // Check repetition
    bool conversationExist = false;

    currentState.conversationGroupList.forEach((ConversationGroup existingConversation) {
      if (existingConversation.id == event.conversationGroup.id) {
        conversationExist = true;
      }
    });

    if (conversationExist) {
      currentState.conversationGroupList
          .removeWhere((ConversationGroup conversationGroup) => conversationGroup.id == event.conversationGroup.id);
      currentState.conversationGroupList.add(event.conversationGroup);
    } else {
      currentState.conversationGroupList.add(event.conversationGroup);
    }

    if (!isObjectEmpty(event)) {
      event.callback(event.conversationGroup);
    }

    return event.conversationGroup;
  }

  Future<UnreadMessage> addUnreadMessageToState(AddUnreadMessageToStateEvent event) async {
    bool unreadMessageExist = false;

    currentState.unreadMessageList.forEach((UnreadMessage existingUnreadMessage) {
      if (existingUnreadMessage.id == event.unreadMessage.id) {
        unreadMessageExist = true;
      }
    });

    if (unreadMessageExist) {
      // Remove existing same id unreadMessage
      currentState.unreadMessageList.removeWhere((existingunreadMessage) => existingunreadMessage.id == event.unreadMessage.id);
      // Read unreadMessage
      currentState.unreadMessageList.add(event.unreadMessage);
    } else {
      currentState.unreadMessageList.add(event.unreadMessage);
    }

    if (!isObjectEmpty(event)) {
      event.callback(event.unreadMessage);
    }

    return event.unreadMessage;
  }

  // Don't have to replace message
  Future<Message> addMessageToState(AddMessageToStateEvent event) async {
    // Check repetition
    bool messageExist = false;

    currentState.messageList.forEach((Message existingMessage) {
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

    return event.message;
  }

  // Don't have to replace multimedia
  Future<Multimedia> addMultimediaToState(AddMultimediaToStateEvent event) async {
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

    return event.multimedia;
  }

  Future<Settings> addSettingsToState(AddSettingsToStateEvent event) async {
    await Firestore.instance.collection('settings').document(event.settings.id).setData({
      'id': generateNewId().toString(), // Self generated Id
      'userId': event.settings.userId,
      'notification': event.settings.notification,
    });
    currentState.settingsState = event.settings;
    if (!isObjectEmpty(event)) {
      event.callback(event.settings);
    }

    return event.settings;
  }

  Future<User> addUserToState(AddUserToStateEvent event) async {
    currentState.userState = event.user;
    if (!isObjectEmpty(event)) {
      event.callback(event.user);
    }

    return event.user;
  }

  Future<UserContact> addUserContactToState(AddUserContactToStateEvent event) async {
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

    return event.userContact;
  }

  addFirebaseAuthToState(AddFirebaseAuthToStateEvent event) async {
    currentState.firebaseAuth = event.firebaseAuth;
    if (!isObjectEmpty(event)) {
      event.callback(event.firebaseAuth);
    }
  }

  addGoogleSignInToState(AddGoogleSignInToStateEvent event) async {
    currentState.googleSignIn = event.googleSignIn;
    if (!isObjectEmpty(event)) {
      event.callback(event.googleSignIn);
    }
  }

  UnreadMessage findUnreadMessage(String conversationId) {
    UnreadMessage unreadMessage;
    unreadMessage = currentState.unreadMessageList.firstWhere((UnreadMessage existingUnreadMessage) {
      return existingUnreadMessage.conversationId == conversationId;
    }, orElse: () => null);

    return unreadMessage;
  }

  Multimedia findMultimediaByConversationId(String conversationId) {
    Multimedia multimedia;
    multimedia = currentState.multimediaList.firstWhere((Multimedia existingMultimedia) {
      return existingMultimedia.conversationId.toString() == conversationId && isStringEmpty(existingMultimedia.messageId);
    }, orElse: () => null);

    return multimedia;
  }

  Multimedia findMultimediaByUserContactId(String userContactId) {
    Multimedia multimedia;
    multimedia = currentState.multimediaList.firstWhere((Multimedia existingMultimedia) {
      return existingMultimedia.userContactId.toString() == userContactId;
    }, orElse: () => null);

    return multimedia;
  }

  List<UserContact> getUserContactsByConversationId(String conversationGroupId) {
    List<UserContact> userContactList = [];

    ConversationGroup conversationGroup = currentState.conversationGroupList.firstWhere((ConversationGroup existingConversationGroup) => existingConversationGroup.id == conversationGroupId, orElse: null);
    print("conversationGroup.id: " + conversationGroup.id);
    conversationGroup.memberIds.forEach((String memberId) => print("conversationGroup.memberId: " + memberId));

    if(isObjectEmpty(conversationGroup)) {
      print("if(isObjectEmpty(conversationGroup))");
      return [];
    }

    if(!isObjectEmpty(conversationGroup.memberIds) && conversationGroup.memberIds.length > 0) {
      for(String memberId in conversationGroup.memberIds) {
        UserContact userContact = currentState.userContactList.firstWhere((UserContact userContact) => userContact.id == memberId);
        if(!isObjectEmpty(userContact)) {
          userContactList.add(userContact);
        }
      }
    }

    return userContactList;
  }

  // Initialize, connect to WebSocket and listen to WebSocketMessage object
  listenToWebSocketMessage(InitializeWebSocketServiceEvent event) {
    webSocketService.connect();
    Stream<dynamic> webSocketStream = webSocketService.getWebSocketStream();
    webSocketStream.listen((onData) {
      print("onData listener is working.");
      print("onData: " + onData.toString());
      WebSocketMessage receivedWebSocketMessage = WebSocketMessage.fromJson(json.decode(onData));
      dispatch(
          ProcessMessageFromWebSocketEvent(webSocketMessage: receivedWebSocketMessage, callback: (WebSocketMessage webSocketMessage) {}));
    }, onError: (onError) {
      print("onError listener is working.");
      print("onError: " + onError.toString());
    }, onDone: () {
      print("onDone listener is working.");
    }, cancelOnError: false);
  }

  // Send WebSocketMessage
  sendWebSocketMessage(SendWebSocketMessageEvent event) async {
    webSocketService.sendWebSocketMessage(event.webSocketMessage);

    if (!isObjectEmpty(event)) {
      event.callback(event.webSocketMessage);
    }
  }

  // Process WebSocketMessage objects to identify what object is inside this object(object in object)
  // Used in 1 place only which is inside InitializeWebSocketServiceEvent
  processMessageFromWebSocket(ProcessMessageFromWebSocketEvent event) async {
    print("ProcessMessageFromWebSocketEvent");
    WebSocketMessage webSocketMessage = event.webSocketMessage;
    if (!isObjectEmpty(webSocketMessage.conversationGroup)) {
      // Conversation Group message
    } else if (!isObjectEmpty(webSocketMessage.message)) {
      // "Message" message
      print("else if(!isObjectEmpty(webSocketMessage.message))");

      if (event.webSocketMessage.message.senderId == currentState.userState.id) {
        // If it's our own message, we won't save it
        // Nothing
      } else {
        // If it's other people message
        print("Other people's message");
        messageDBService.addMessage(event.webSocketMessage.message);

        dispatch(AddMessageToStateEvent(message: event.webSocketMessage.message, callback: (Message message) {}));
      }
    } else if (!isObjectEmpty(webSocketMessage.multimedia)) {
      // Multimedia message

    } else if (!isObjectEmpty(webSocketMessage.settings)) {
      // Settings message

    } else if (!isObjectEmpty(webSocketMessage.unreadMessage)) {
      // UnreadMessage message

    } else if (!isObjectEmpty(webSocketMessage.user)) {
      // User message

    } else if (!isObjectEmpty(webSocketMessage.userContact)) {
      // UserContact message

    }

    if (!isObjectEmpty(event)) {
      event.callback(event.webSocketMessage);
    }
  }
}
