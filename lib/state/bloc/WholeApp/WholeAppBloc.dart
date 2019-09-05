import 'dart:async';

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
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart' as prefix0;
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';
import 'package:snschat_flutter/service/permissions/PermissionService.dart';
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
    } else if (event is GetConversationsForUserEvent) {
      loadConversationsOfTheUser(event);
      yield currentState;
    } else if (event is AddConversationGroupEvent) {
      addConversationToState(event);
      yield currentState;
    } else if (event is AddMessageEvent) {
      addMessageToState(event);
      yield currentState;
    } else if (event is AddMultimediaEvent) {
      addMultimediaToState(event);
      yield currentState;
    } else if (event is AddSettingsEvent) {
      addSettingsToState(event);
      yield currentState;
    } else if (event is AddUserEvent) {
      addUserToState(event);
      yield currentState;
    } else if (event is AddUserContactEvent) {
      addUserContactToState(event);
      yield currentState;
    } else if (event is AddContactEvent) {
      addContactToState(event);
      yield currentState;
    } else if (event is AddFirebaseAuthEvent) {
      addFirebaseAuthToState(event);
      yield currentState;
    } else if (event is AddGoogleSignInEvent) {
      addGoogleSignInToState(event);
      yield currentState;
    } else if (event is OverrideUnreadMessageEvent) {
      overrideUnreadMessageEvent(event);
      yield currentState;
    } else if (event is CreateConversationGroupEvent) {
      createConversationGroup(event);
    }
  }

  // Check user is signed into the google or not
  // Because if signed in Google SDK library is programmed to remember it every time you open your app
  // Developer doesn't have save those Google data by themselves
  Future<bool> checkUserSignIn(CheckUserLoginEvent event) async {
    print("checkUserSignIn()");
    bool isSignedIn = false;

    isSignedIn = await currentState.googleSignIn.isSignedIn();
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
    bool googleSignInDone = await signInUsingGoogle();
    if (!googleSignInDone) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    }
    User userFromDB = await userDBService.getUserByGoogleAccountId(currentState.googleSignIn.currentUser.id);

    if (userFromDB == null) {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    }

    Settings settingsFromDB = await settingsDBService.getSettingsOfAUser(userFromDB.id);

    if (settingsFromDB == null) {
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

    addUserToState(AddUserEvent(user: userFromDB, callback: (User user) {}));
    addSettingsToState(AddSettingsEvent(settings: settingsFromDB, callback: (Settings settings) {}));
    currentState.conversationGroupList = conversationGroupListFromDB;
    currentState.messageList = messageListFromDB;
    currentState.multimediaList = multimediaListFromDB;
    currentState.unreadMessageList = unreadMessageListFromDB;
    currentState.userContactList = userContactListFromDB;

    if (!isObjectEmpty(event)) {
      event.callback(true);
    }

    return true;
  }

  // Sign in using Google.
  // Will check user signed up or not first. If signed up, will read User data from Firebase
  // Output: The state will have GoogleAccount, FirebaseUser, User, Settings data
  Future<bool> signIn(UserSignInEvent event) async {
    bool isSignedUp = await checkUserSignedUp(CheckUserSignedUpEvent(callback: (bool isSignedUp) {}, mobileNo: event.mobileNo));

    if (isSignedUp) {
      bool googleSignedIn = await signInUsingGoogle();
      if (!googleSignedIn) {
        if (!isObjectEmpty(event)) {
          event.callback(false);
        }
        return false;
      }

      bool getUserSuccessful = await getUserAndSettings();
      if (getUserSuccessful) {
        // In case of Sign in from login page, check mobile no with state's mobile no got from Firebase's User table
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
    } else {
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }

      return false;
    }
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
    if (!isObjectEmpty(currentState.firebaseUser)) {
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
    }
    return false;
  }

  // Sign up a new User record in FireStore using GoogleAccount & FirebaseUser
  Future<bool> signUp(UserSignUpEvent event) async {
    try {
      // Require user to connect to Google first in order to get some info from the user
      bool isSignedIn = await signInUsingGoogle();

      if (isSignedIn) {
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
          bool accountExist = await isAccountExist(user);
          print("accountExist: " + accountExist.toString());
          if (!accountExist) {
            bool created = await createSettingsAndUser(user, settings);

            if (!isObjectEmpty(event)) {
              event.callback(created);
            }

            return created;
          } else {
            Fluttertoast.showToast(
                msg: 'Registered Mobile No./Google Account. Please use another Mobile No./Google Account to register.',
                toastLength: Toast.LENGTH_SHORT);
            if (!isObjectEmpty(event)) {
              event.callback(false);
            }
            return false;
          }
        }
      }
      if (!isObjectEmpty(event)) {
        event.callback(false);
      }
    } catch (e) {
      return false;
    }

    return false;
  }

  Future<bool> isAccountExist(User user) async {
    // Check REST API
    User userFromServer = await userAPIService.getUserByUsingGoogleAccountId(user.googleAccountId);
    User userFromServer2 = await userAPIService.getUserByUsingMobileNo(user.mobileNo);

    // Exist = true, Not Exist = false;
    bool result = userFromServer != null && userFromServer2 != null;
    print("duplicate? " + result.toString());
    return result;
  }

  Future<bool> createSettingsAndUser(User user, Settings settings) async {
    // REST API --> Local DB

    // Check first before create one
    User userFromServer = await userAPIService.addUser(user);
    if (userFromServer == null) {
      return false;
    }

    settings.userId = user.id = userFromServer.id;

    bool userSaved = await userDBService.addUser(user);
    if (!userSaved) {
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
      currentState.phoneContactList = currentState.phoneContactList.toSet().toList();
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

  Future<bool> loadConversationsOfTheUser(GetConversationsForUserEvent event) async {
    List<ConversationGroup> conversationGroupListFromDB = await conversationGroupDBService.getAllConversationGroups();
    currentState.conversationGroupList = conversationGroupListFromDB;
    List<ConversationGroup> conversationGroupListFromServer =
        await conversationGroupAPIService.getConversationGroupsForUser(currentState.userState.id);
    if (conversationGroupListFromServer != null && conversationGroupListFromServer.length > 0) {
      // Update the current info of the conversationGroup to latest information
      conversationGroupListFromServer.forEach((conversationGroupFromServer) {
        // TODO: Review the performance of this loop
        bool conversationGroupExist = conversationGroupListFromDB
            .contains((ConversationGroup conversatGroupFromDB) => conversatGroupFromDB.id == conversationGroupFromServer.id);
        if (conversationGroupExist) {
          conversationGroupDBService.editConversationGroup(conversationGroupFromServer);
        } else {
          conversationGroupDBService.addConversationGroup(conversationGroupFromServer);
        }
        addConversationToState(AddConversationGroupEvent(callback: () {}, conversationGroup: conversationGroupFromServer));
      });
    }

    if (!isObjectEmpty(event)) {
      event.callback(true);
    }

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

  Future<bool> createConversationGroup(CreateConversationGroupEvent event) async {
    // Create Single Group successfully (1 ConversationGroup, 2 UserContact, 1 UnreadMessage, 1 Multimedia)
    // Upload conversation to REST API and Local DB

    UserContact yourOwnUserContact = UserContact(
      id: null,
      userIds: [currentState.userState.id],
      // Which User owns this UserContact
      displayName: currentState.userState.displayName,
      realName: currentState.userState.realName,
      block: false,
      lastSeenDate: "",
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
      }

      UserContact userContact = UserContact(
        id: null,
        userIds: [currentState.userState.id],
        // So this contact number is mine. Later send it to backend and merge with other UserContact who got the same number
        displayName: contact.displayName,
        realName: contact.displayName,
        block: false,
        lastSeenDate: "",
      );

      userContact.mobileNo = primaryNo.length == 0 ? "" : primaryNo[0];
      print("primaryNo[0]: " + primaryNo[0]);

      // If got Malaysia number
      if (primaryNo[0].contains("+60")) {
        print("If Malaysian Number: ");
        String trimmedString = primaryNo[0].substring(3);
        print("trimmedString: " + trimmedString);
      }

      userContactList.add(userContact);
    });

    List<UserContact> newUserContactList = [];
    userContactList.forEach((userContact) async {
      // findUserContact(targetUserContact);
      UserContact existingUserContact = await userContactAPIService.getUserContactByMobileNo(userContact.mobileNo);
      if(existingUserContact == null) {
        // There's userContact that has the same mobile number
        UserContact newUserContact = await userContactAPIService.addUserContact(userContact);
        if (newUserContact != null) {
          newUserContactList.add(newUserContact);
        }

        // Weakness: No error handling if UserContact save to DB fails
        userContactDBService.addUserContact(userContact);

      } else {

      }
    });

    print("event.contactList.length: " + event.contactList.length.toString());
    print("newUserContactList.length: " + newUserContactList.length.toString());

    // event.contactList doesn't include yourself, so newUserContactList need to remove yourself first
    if (event.contactList.length != newUserContactList.length - 1) {
      // That means some UseContact are not uploaded into the REST
      return false;
    }

    // Replace the list with no Id with the one with Ids
    userContactList = newUserContactList;

    // Give the list of UserContactIds to memberIds of ConversationGroup
    event.conversationGroup.memberIds = userContactList.map((newUserContact) {
      return newUserContact.id;
    });

    // ConversationGroup upload first
    ConversationGroup newConversationGroup = await conversationGroupAPIService.addConversationGroup(event.conversationGroup);

    if (isStringEmpty(newConversationGroup.id)) {
      return false;
    }

    bool conversationGroupSaved = await conversationGroupDBService.addConversationGroup(newConversationGroup);

    if (!conversationGroupSaved) {
      return false;
    }
    // TODO: Create Single Group successfully (1 ConversationGroup, 2 UserContact, 1 UnreadMessage, 1 Multimedia)

    UnreadMessage unreadMessage = UnreadMessage(
      id: null,
      conversationId: newConversationGroup.id,
      count: 0,
      date: DateTime.now().millisecondsSinceEpoch,
      lastMessage: "",
      userId: newConversationGroup.creatorUserId,
    );

    UnreadMessage newUnreadMessage = await unreadMessageAPIService.addUnreadMessage(unreadMessage);

    if (isStringEmpty(newUnreadMessage.id)) {
      return false;
    }

    bool unreadMessageSaved = await unreadMessageDBService.addUnreadMessage(newUnreadMessage);

    if (!unreadMessageSaved) {
      return false;
    }

    Multimedia newMultimedia = await multimediaAPIService.addMultimedia(event.multimedia);

    if (isStringEmpty(newMultimedia.id)) {
      return false;
    }

    bool conversationGroupMultimediaSaved = await multimediaDBService.addMultimedia(newMultimedia);

    if (!conversationGroupMultimediaSaved) {
      return false;
    }

    userContactList.forEach((userContact) {
      userContactDBService.addUserContact(userContact);
    });

    switch (event.type) {
      case "Single":
        break;
      case "Group":
        break;
      case "Broadcast":
        break;
      default:
        return false;
        break;
    }
    return true;
  }

  addConversationToState(AddConversationGroupEvent event) async {
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

    if (!conversationExist) {
      currentState.conversationGroupList.add(event.conversationGroup);
    }
    if (!isObjectEmpty(event)) {
      event.callback(event.conversationGroup);
    }
  }

  overrideUnreadMessageEvent(OverrideUnreadMessageEvent event) async {
    print('event.unreadMessage.id: ' + event.unreadMessage.id);
    // Remove existing same id unreadMessage
    currentState.unreadMessageList.removeWhere((existingunreadMessage) => existingunreadMessage.id == event.unreadMessage.id);
    // Read unreadMessage
    currentState.unreadMessageList.add(event.unreadMessage);
    if (!isObjectEmpty(event)) {
      event.callback(event.unreadMessage);
    }
  }

  addMessageToState(AddMessageEvent event) async {
    print("event.message.id: " + event.message.id);
    // Check repetition
    bool messageExist = false;

    currentState.conversationGroupList.forEach((ConversationGroup existingMessage) {
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

  addMultimediaToState(AddMultimediaEvent event) async {
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

  addSettingsToState(AddSettingsEvent event) async {
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

  addUserToState(AddUserEvent event) async {
    print("event.message.id: " + event.user.id);
    currentState.userState = event.user;
    if (!isObjectEmpty(event)) {
      event.callback(event.user);
    }
  }

  addUserContactToState(AddUserContactEvent event) async {
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

  addContactToState(AddContactEvent event) async {
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

  addFirebaseAuthToState(AddFirebaseAuthEvent event) async {
    print("event.firebaseAuth.app.name: " + event.firebaseAuth.app.name);
    currentState.firebaseAuth = event.firebaseAuth;
    if (!isObjectEmpty(event)) {
      event.callback(event.firebaseAuth);
    }
  }

  addGoogleSignInToState(AddGoogleSignInEvent event) async {
    print("event.googleSignIn.currentUser.displayName: " + event.googleSignIn.currentUser.displayName);
    currentState.googleSignIn = event.googleSignIn;
    if (!isObjectEmpty(event)) {
      event.callback(event.googleSignIn);
    }
  }
}
