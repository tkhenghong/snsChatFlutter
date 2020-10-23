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
    } else if (event is EditOwnUserContactEvent) {
      yield* _editOwnUserContact(event);
    } else if (event is GetUserContactEvent) {
      yield* _getUserContact(event);
    } else if (event is GetUserContactByUserIdEvent) {
      yield* _getUserContactByUserId(event);
    } else if (event is GetUserOwnUserContactEvent) {
      yield* _getUserOwnUserContactEvent(event);
    } else if (event is GetUserOwnUserContactsEvent) {
      yield* _getUserOwnUserContactsEvent(event);
    } else if (event is GetUserContactByMobileNoEvent) {
      yield* _getUserContactByMobileNo(event);
    } else if (event is RemoveAllUserContactsEvent) {
      yield* _removeAllUserContactsEvent(event);
    }
  }

  Stream<UserContactState> _initializeUserContactsToState(InitializeUserContactsEvent event) async* {
    if (state is UserContactsLoading || state is UserContactsNotLoaded) {
      try {
        List<UserContact> userContactListFromDB = await userContactDBService.getAllUserContacts();

        if (userContactListFromDB.isEmpty) {
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

  Stream<UserContactState> _getUserContact(GetUserContactEvent event) async* {
    if (event.userContactId.isNotEmpty) {
      UserContact userContactFromServer = await userContactAPIService.getUserContact(event.userContactId);

      if (!userContactFromServer.isNull) {
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
    if (!event.user.isNull) {
      UserContact userContactFromDB = await userContactDBService.getUserContactByUserId(event.user.id);

      functionCallback(event, userContactFromDB);
    } else {
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _getUserOwnUserContactEvent(GetUserOwnUserContactEvent event) async* {
    UserContact ownUserContact = await userContactAPIService.getOwnUserContact();

    if (!ownUserContact.isNull) {
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

    if (!userContactListFromServer.isNullOrBlank && userContactListFromServer.isNotEmpty) {
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

      if (!existingStateUserContact.isNull) {
        // Local UserContact found, update the UserContact.
        updatedUserContact = await userContactAPIService.getUserContact(existingStateUserContact.id);
      } else {
        // LocalDB UserContact not found, search in backend.
        updatedUserContact = await userContactAPIService.getUserContactByMobileNo(event.mobileNo);
      }

      if (!updatedUserContact.isNull) {
        addUserContactIntoDB(updatedUserContact);
        List<UserContact> existingUserContactList = addUserContactIntoState(updatedUserContact);

        yield* yieldUserContactState(updatedUserContactList: existingUserContactList);
      }

      functionCallback(event, updatedUserContact);
    }
  }

  Stream<UserContactState> _removeAllUserContactsEvent(RemoveAllUserContactsEvent event) async* {
    userContactDBService.deleteAllUserContacts();
    yield UserContactsNotLoaded();
    functionCallback(event, true);
  }

  Future<bool> addUserContactIntoDB(UserContact userContact) async {
    bool added = false;

    UserContact userContactInDB = await userContactDBService.getSingleUserContact(userContact.id);
    if (!userContactInDB.isNull) {
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

  Stream<UserContactState> yieldUserContactState({UserContact updatedOwnUserContact, List<UserContact> updatedUserContactList}) async* {
    UserContact existingOwnUserContact;
    List<UserContact> existingUserContactList;

    if (state is UserContactsLoaded) {
      existingOwnUserContact = (state as UserContactsLoaded).ownUserContact;
      existingUserContactList = (state as UserContactsLoaded).userContactList;

      if (!updatedOwnUserContact.isNull) {
        existingOwnUserContact = updatedOwnUserContact;
      }

      if (updatedUserContactList.isNotEmpty) {
        existingUserContactList = updatedUserContactList;
      }
    }

    yield UserContactsLoading(); // Need change state for BlOC to detect changes.
    if (existingUserContactList.isEmpty && existingOwnUserContact.isNull) {
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
