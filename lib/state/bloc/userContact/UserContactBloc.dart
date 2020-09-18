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
    } else if (event is AddUserContactEvent) {
      yield* _addUserContact(event);
    } else if (event is EditUserContactEvent) {
      yield* _editUserContact(event);
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
    } else if (event is AddMultipleUserContactEvent) {
      yield* _addMultipleUserContact(event);
    } else if (event is GetUserContactByMobileNoEvent) {
      yield* _getUserContactByMobileNo(event);
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

  Stream<UserContactState> _addUserContact(AddUserContactEvent event) async* {
    UserContact newUserContact;
    bool userContactAdded = false;

    // Avoid reading existing userContact
    if (isStringEmpty(event.userContact.id)) {
      newUserContact = await userContactAPIService.addUserContact(event.userContact);
    }

    if (!isObjectEmpty(newUserContact)) {
      userContactAdded = await userContactDBService.addUserContact(newUserContact);
      if (userContactAdded) {
        List<UserContact> existingUserContactList = [];

        if (state is UserContactsLoaded) {
          existingUserContactList = (state as UserContactsLoaded).userContactList;
        }

        existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

        existingUserContactList.add(event.userContact);

        yield UserContactsLoaded(existingUserContactList);
        functionCallback(event, event.userContact);
      }
    }

    if (isObjectEmpty(newUserContact) || !userContactAdded) {
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _addMultipleUserContact(AddMultipleUserContactEvent event) async* {
    List<UserContact> existingUserContactList = [];
    List<UserContact> newUserContactList = [];

    if (state is UserContactsLoaded) {
      UserContactsLoaded userContactsLoaded = (state as UserContactsLoaded);
      existingUserContactList = userContactsLoaded.userContactList;

      for (UserContact userContact in event.userContactList) {
        UserContact newUserContact;
        bool userContactAdded = false;

        // Avoid reading existing userContact
        if (isStringEmpty(userContact.id)) {
          newUserContact = await userContactAPIService.addUserContact(userContact);
        }

        if (!isObjectEmpty(newUserContact)) {
          bool userContactExist = false;

          for (UserContact existingUserContact in existingUserContactList) {
            if (existingUserContact.id == newUserContact.id) {
              userContactExist = true;
            }
          }
          if (userContactExist) {
            userContactAdded = await userContactDBService.editUserContact(newUserContact);
          } else {
            userContactAdded = await userContactDBService.addUserContact(newUserContact);
          }

          existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == newUserContact.id);

          if (userContactAdded) {
            newUserContactList.add(userContact);
          }
        }

        if (isObjectEmpty(newUserContact) || !userContactAdded) {
          functionCallback(event, []);
          return; // Any error, out
        }
      }

      existingUserContactList = [existingUserContactList, newUserContactList].expand((x) => x).toList();

      yield UserContactsLoaded(existingUserContactList, userContactsLoaded.ownUserContact);
    }
    functionCallback(event, newUserContactList);
  }

  Stream<UserContactState> _editUserContact(EditUserContactEvent event) async* {
    bool updatedInREST = false;
    bool userContactEdited = false;

    if (state is UserContactsLoaded) {
      bool updatedInREST = await userContactAPIService.editUserContact(event.userContact);

      if (updatedInREST) {
        bool userContactEdited = await userContactDBService.editUserContact(event.userContact);

        if (userContactEdited) {
          UserContactsLoaded userContactsLoaded = (state as UserContactsLoaded);
          List<UserContact> existingUserContactList = userContactsLoaded.userContactList;

          existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

          existingUserContactList.add(event.userContact);

          yield UserContactsLoaded(existingUserContactList, userContactsLoaded.ownUserContact);
          functionCallback(event, event.userContact);
        }
      }
    }

    if (!updatedInREST || !userContactEdited) {
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _deleteUserContact(DeleteUserContactEvent event) async* {
    bool deletedInREST = false;
    bool deleted = false;

    if (state is UserContactsLoaded) {
      deletedInREST = await userContactAPIService.deleteUserContact(event.userContact.id);

      if (deletedInREST) {
        deleted = await userContactDBService.deleteUserContact(event.userContact.id);

        if (deleted) {
          UserContactsLoaded userContactsLoaded = (state as UserContactsLoaded);
          List<UserContact> existingUserContactList = userContactsLoaded.userContactList;

          existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

          yield UserContactsLoaded(existingUserContactList, userContactsLoaded.ownUserContact);
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
        functionCallback(event, userContactFromServer);
      } else {
        functionCallback(event, null);
      }
    }
  }

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
    if (state is UserContactsLoaded) {
      addUserContactIntoDB(ownUserContact);

      List<UserContact> userContactList = addUserContactIntoState(ownUserContact);

      yield UserContactsLoading(); // Need change state for BlOC to detect changes.

      yield UserContactsLoaded(userContactList, ownUserContact);
      functionCallback(event, true);
    }
  }

  Stream<UserContactState> _getUserOwnUserContactsEvent(GetUserOwnUserContactsEvent event) async* {
    List<UserContact> userContactListFromServer = await userContactAPIService.getUserContactsByUserId();
    if (state is UserContactsLoaded) {
      if (!isObjectEmpty(userContactListFromServer) && userContactListFromServer.length > 0) {
        for (UserContact userContactFromServer in userContactListFromServer) {
          bool added = await addUserContactIntoDB(userContactFromServer);

          if(added) {
            List<UserContact> updatedUserContactList = addUserContactIntoState(userContactFromServer);
            UserContact ownUserContact = (state as UserContactsLoaded).ownUserContact;
            yield UserContactsLoaded(updatedUserContactList, ownUserContact);
          }
        }
      }
      functionCallback(event, true);
    }
  }

  Stream<UserContactState> _getUserContactByMobileNo(GetUserContactByMobileNoEvent event) async* {
    UserContact userContact = await userContactAPIService.getUserContactByMobileNo(event.mobileNo);
    if (state is UserContactsLoaded) {
      if (!isObjectEmpty(userContact)) {
        UserContact dbUserContact = await userContactDBService.getSingleUserContact(userContact.id);

        if(!isObjectEmpty(dbUserContact)) {
          await userContactDBService.deleteUserContact(userContact.id);
        }

        await userContactDBService.addUserContact(userContact);

        List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

        existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == userContact.id);

        existingUserContactList.add(userContact);

        yield UserContactsLoaded(existingUserContactList);
      }

      functionCallback(event, userContact);
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

  List<UserContact> addUserContactIntoState(UserContact userContact) {
    List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

    existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == userContact.id);

    existingUserContactList.add(userContact);

    return existingUserContactList;
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
