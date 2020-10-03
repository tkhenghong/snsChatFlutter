import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/state/bloc/userContact/bloc.dart';

class UserContactBloc extends Bloc<UserContactEvent, UserContactState> {
  UserContactBloc() : super(UserContactsLoading());

  UserContactAPIService userContactAPIService = Get.find();
  UserContactDBService userContactDBService = Get.find();

  @override
  Stream<UserContactState> mapEventToState(UserContactEvent event) async* {
    if (event is InitializeUserContactsEvent) {
      yield* _initializeUserContactsToState(event);
    }
    // else if (event is AddUserContactEvent) {
    //   yield* _addUserContact(event);
    // }
    else if (event is EditOwnUserContactEvent) {
      yield* _editOwnUserContact(event);
    } else if (event is DeleteUserContactEvent) {
      yield* _deleteUserContact(event);
    } else if (event is GetUserContactEvent) {
      _getUserContact(event);
    } else if (event is GetUserContactByUserIdEvent) {
      yield* _getUserContactByUserId(event);
    } else if (event is GetUserOwnUserContactEvent) {
      yield* _getUserOwnUserContactEvent(event);
    } else if (event is GetUserOwnUserContactsEvent) {
      yield* _getUserOwnUserContactsEvent(event);
    }
    // else if (event is AddMultipleUserContactEvent) {
    //   yield* _addMultipleUserContact(event);
    // }
    else if (event is GetUserContactByMobileNoEvent) {
      yield* _getUserContactByMobileNo(event);
    } else if (event is RemoveAllUserContactsEvent) {
      yield* _removeAllUserContactsEvent(event);
    }
  }

  Stream<UserContactState> _initializeUserContactsToState(InitializeUserContactsEvent event) async* {
    if (state is UserContactsLoading || state is UserContactsNotLoaded) {
      try {
        List<UserContact> userContactListFromDB = await userContactDBService.getAllUserContacts();

        if (isObjectEmpty(userContactListFromDB)) {
          yield UserContactsNotLoaded();
          functionCallback(event, false);
        } else {
          yield UserContactsLoaded(userContactListFromDB);
          functionCallback(event, true);
        }
      } catch (e) {
        yield UserContactsNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  // Deprecated: Due to not adding user contact from the frontend. Architecture changed.
  // Stream<UserContactState> _addUserContact(AddUserContactEvent event) async* {
  //   UserContact newUserContact;
  //   bool userContactAdded = false;
  //
  //   // Avoid reading existing userContact
  //   if (isStringEmpty(event.userContact.id)) {
  //     newUserContact = await userContactAPIService.addUserContact(event.userContact);
  //   }
  //
  //   if (!isObjectEmpty(newUserContact)) {
  //     userContactAdded = await userContactDBService.addUserContact(newUserContact);
  //     if (userContactAdded) {
  //       List<UserContact> existingUserContactList = [];
  //
  //       if (state is UserContactsLoaded) {
  //         existingUserContactList = (state as UserContactsLoaded).userContactList;
  //       }
  //
  //       existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);
  //
  //       existingUserContactList.add(event.userContact);
  //
  //       yield UserContactsLoaded(existingUserContactList);
  //       functionCallback(event, event.userContact);
  //     }
  //   }
  //
  //   if (isObjectEmpty(newUserContact) || !userContactAdded) {
  //     functionCallback(event, null);
  //   }
  // }

  // Deprecated: Due to not adding Multiple user contacts from the frontend. Architecture changed.
  // Stream<UserContactState> _addMultipleUserContact(AddMultipleUserContactEvent event) async* {
  //   List<UserContact> existingUserContactList = [];
  //   List<UserContact> newUserContactList = [];
  //
  //   if (state is UserContactsLoaded) {
  //     UserContactsLoaded userContactsLoaded = (state as UserContactsLoaded);
  //     existingUserContactList = userContactsLoaded.userContactList;
  //
  //     for (UserContact userContact in event.userContactList) {
  //       UserContact newUserContact;
  //       bool userContactAdded = false;
  //
  //       // Avoid reading existing userContact
  //       if (isStringEmpty(userContact.id)) {
  //         newUserContact = await userContactAPIService.addUserContact(userContact);
  //       }
  //
  //       if (!isObjectEmpty(newUserContact)) {
  //         bool userContactExist = false;
  //
  //         for (UserContact existingUserContact in existingUserContactList) {
  //           if (existingUserContact.id == newUserContact.id) {
  //             userContactExist = true;
  //           }
  //         }
  //         if (userContactExist) {
  //           userContactAdded = await userContactDBService.editUserContact(newUserContact);
  //         } else {
  //           userContactAdded = await userContactDBService.addUserContact(newUserContact);
  //         }
  //
  //         existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == newUserContact.id);
  //
  //         if (userContactAdded) {
  //           newUserContactList.add(userContact);
  //         }
  //       }
  //
  //       if (isObjectEmpty(newUserContact) || !userContactAdded) {
  //         functionCallback(event, []);
  //         return; // Any error, out
  //       }
  //     }
  //
  //     existingUserContactList = [existingUserContactList, newUserContactList].expand((x) => x).toList();
  //
  //     yield UserContactsLoaded(existingUserContactList, userContactsLoaded.ownUserContact);
  //   }
  //   functionCallback(event, newUserContactList);
  // }

  // Only updates the user's own UserContact.
  Stream<UserContactState> _editOwnUserContact(EditOwnUserContactEvent event) async* {
    bool updatedInREST = false;
    bool userContactEdited = false;

    if (state is UserContactsLoaded) {
      bool updatedInREST = await userContactAPIService.editOwnUserContact(event.userContact);

      if (updatedInREST) {
        userContactEdited = await addUserContactIntoDB(event.userContact);

        if (userContactEdited) {
          List<UserContact> existingUserContactList = addUserContactIntoState(event.userContact);

          yield* yieldUserContactState(updatedUserContactList: existingUserContactList);
          functionCallback(event, event.userContact);
        }
      }
    }

    if (!updatedInREST || !userContactEdited) {
      functionCallback(event, null);
      throw Exception('Not able to update own user contact.');
    }
  }

  // Only happens when user is deleting his/her account.
  Stream<UserContactState> _deleteUserContact(DeleteUserContactEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;

    if (state is UserContactsLoaded) {
      deletedInREST = await userContactAPIService.deleteUserContact(event.userContact.id);

      if (deletedInREST) {
        deleted = await userContactDBService.deleteUserContact(event.userContact.id);

        if (deleted) {
          List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

          existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

          yield* yieldUserContactState(updatedUserContactList: existingUserContactList);
          functionCallback(event, true);
        }
      }
    }

    if (!deletedInREST || !deleted) {
      functionCallback(event, false);
    }
  }

  Stream<UserContactState> _getUserContact(GetUserContactEvent event) async* {
    if (!isStringEmpty(event.userContactId)) {
      UserContact userContactFromServer = await userContactAPIService.getUserContact(event.userContactId);

      if (!isObjectEmpty(userContactFromServer)) {
        addUserContactIntoDB(userContactFromServer);
        List<UserContact> updatedUserContactList = addUserContactIntoState(userContactFromServer);

        yield* yieldUserContactState(updatedUserContactList: updatedUserContactList);
        functionCallback(event, userContactFromServer);
      } else {
        functionCallback(event, null);
      }
    }
  }

  // Not used until multiple user login happens.
  Stream<UserContactState> _getUserContactByUserId(GetUserContactByUserIdEvent event) async* {
    if (!isObjectEmpty(event.user)) {
      UserContact userContactFromDB = await userContactDBService.getUserContactByUserId(event.user.id);

      functionCallback(event, userContactFromDB);
    } else {
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _getUserOwnUserContactEvent(GetUserOwnUserContactEvent event) async* {
    UserContact ownUserContact = await userContactAPIService.getOwnUserContact();

    if (!isObjectEmpty(ownUserContact)) {
      addUserContactIntoDB(ownUserContact);
      List<UserContact> updatedUserContactList = addUserContactIntoState(ownUserContact);
      yield* yieldUserContactState(updatedUserContactList: updatedUserContactList, updatedOwnUserContact: ownUserContact);
      functionCallback(event, true);
    } else {
      functionCallback(event, false);
    }
  }

  Stream<UserContactState> _getUserOwnUserContactsEvent(GetUserOwnUserContactsEvent event) async* {
    List<UserContact> userContactListFromServer = await userContactAPIService.getOwnUserContacts();

    if (!isObjectEmpty(userContactListFromServer) && userContactListFromServer.length > 0) {
      for (UserContact userContactFromServer in userContactListFromServer) {
        addUserContactIntoDB(userContactFromServer);
        List<UserContact> updatedUserContactList = addUserContactIntoState(userContactFromServer);
        yield* yieldUserContactState(updatedUserContactList: updatedUserContactList);
      }

      functionCallback(event, true);
    } else {
      functionCallback(event, false);
    }
  }

  Stream<UserContactState> _getUserContactByMobileNo(GetUserContactByMobileNoEvent event) async* {
    if (state is UserContactsLoaded) {
      List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

      UserContact existingStateUserContact = existingUserContactList.firstWhere((element) => element.mobileNo == event.mobileNo, orElse: () => null);

      UserContact updatedUserContact;

      if (!isObjectEmpty(existingStateUserContact)) {
        // Local UserContact found, update the UserContact.
        updatedUserContact = await userContactAPIService.getUserContact(existingStateUserContact.id);
      } else {
        // LocalDB UserContact not found, search in backend.
        updatedUserContact = await userContactAPIService.getUserContactByMobileNo(event.mobileNo);
      }

      if (!isObjectEmpty(updatedUserContact)) {
        addUserContactIntoDB(updatedUserContact);
        List<UserContact> existingUserContactList = addUserContactIntoState(updatedUserContact);

        yield* yieldUserContactState(updatedUserContactList: existingUserContactList);
      }

      functionCallback(event, updatedUserContact);
    }
  }

  Future<bool> addUserContactIntoDB(UserContact userContact) async {
    bool added = false;

    UserContact userContactInDB = await userContactDBService.getSingleUserContact(userContact.id);
    if (!isObjectEmpty(userContactInDB)) {
      added = await userContactDBService.editUserContact(userContact);
    } else {
      added = await userContactDBService.addUserContact(userContact);
    }

    return added;
  }

  Stream<UserContactState> _removeAllUserContactsEvent(RemoveAllUserContactsEvent event) async* {
    userContactDBService.deleteAllUserContacts();
    yield UserContactsNotLoaded();
    functionCallback(event, true);
  }

  List<UserContact> addUserContactIntoState(UserContact userContact) {
    List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

    existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == userContact.id);

    existingUserContactList.add(userContact);

    return existingUserContactList;
  }

  Stream<UserContactState> yieldUserContactState({UserContact updatedOwnUserContact, List<UserContact> updatedUserContactList}) async* {
    UserContact existingOwnUserContact;
    List<UserContact> existingUserContactList;

    if (state is UserContactsLoaded) {
      existingOwnUserContact = (state as UserContactsLoaded).ownUserContact;
      existingUserContactList = (state as UserContactsLoaded).userContactList;

      if (!isObjectEmpty(updatedOwnUserContact)) {
        existingOwnUserContact = updatedOwnUserContact;
      }

      if (!isObjectEmpty(updatedUserContactList)) {
        existingUserContactList = updatedUserContactList;
      }
    }

    yield UserContactsLoading(); // Need change state for BlOC to detect changes.
    if (isObjectEmpty(existingUserContactList) && isObjectEmpty(existingOwnUserContact)) {
      yield UserContactsNotLoaded();
    } else {
      yield UserContactsLoaded(existingUserContactList, existingOwnUserContact);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
