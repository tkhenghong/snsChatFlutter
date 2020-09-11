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

    // Avoid readding existing userContact
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
      existingUserContactList = (state as UserContactsLoaded).userContactList;
    }

    for (UserContact userContact in event.userContactList) {
      UserContact newUserContact;
      bool userContactAdded = false;

      // Avoid readding existing userContact
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

    yield UserContactsLoaded(existingUserContactList);
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
          List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

          existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

          existingUserContactList.add(event.userContact);

          yield UserContactsLoaded(existingUserContactList);
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
          List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

          existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

          yield UserContactsLoaded(existingUserContactList);
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

  Stream<UserContactState> _getUserOwnUserContactsEvent(GetUserOwnUserContactsEvent event) async* {
    List<UserContact> userContactListFromServer = await userContactAPIService.getUserContactsByUserId();
    if (state is UserContactsLoaded) {
      List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

      if (!isObjectEmpty(userContactListFromServer) && userContactListFromServer.length > 0) {
        for (UserContact userContactFromServer in userContactListFromServer) {
          // Unable to use contains() method here. Will cause concurrent modification during iteration problem.
          // Link: https://stackoverflow.com/questions/22409666/exception-concurrent-modification-during-iteration-instancelength17-of-gr
          bool userContactExist = false;
          for (UserContact existingUserContact in existingUserContactList) {
            if (existingUserContact.id == userContactFromServer.id) {
              userContactExist = true;
            }
          }

          if (userContactExist) {
            existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == userContactFromServer.id);
            userContactDBService.editUserContact(userContactFromServer);
          } else {
            userContactDBService.addUserContact(userContactFromServer);
          }

          existingUserContactList.add(userContactFromServer);
        }
      }

      yield UserContactsLoaded(existingUserContactList);
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

      functionCallback(userContact, true);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
