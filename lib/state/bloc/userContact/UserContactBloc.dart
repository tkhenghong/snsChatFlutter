import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        List<UserContact> userContactListFromDB = await userContactDBService.getAllUserContactsWithPagination(event.page, event.size);

        yield* yieldUserContactState(updatedUserContactList: userContactListFromDB);
        functionCallback(event, true);
      } catch (e) {
        showToast('Failed to load user contacts. Please try again later.', Toast.LENGTH_LONG);
        functionCallback(event, false);
      }
    }
  }

  // Only updates the user's own UserContact.
  Stream<UserContactState> _editOwnUserContact(EditOwnUserContactEvent event) async* {
    bool userContactEdited = false;

    try {
      if (state is UserContactsLoaded) {
        UserContact updatedUserContact = await userContactAPIService.editOwnUserContact(event.userContact);

        if (!isObjectEmpty(updatedUserContact)) {
          userContactEdited = await userContactDBService.addUserContact(updatedUserContact);

          if (userContactEdited) {
            yield* yieldUserContactState(updatedOwnUserContact: updatedUserContact, userContact: updatedUserContact);
            functionCallback(event, event.userContact);
            userContactEdited = true;
          }
        } else {
          userContactEdited = false;
        }
      }
    } catch (e) {
      userContactEdited = false;
    }

    if (!userContactEdited) {
      showToast('Not able to edit own user contact info. Please try again later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _getUserContact(GetUserContactEvent event) async* {
    try {
      if (event.userContactId.isNotEmpty) {
        UserContact userContactFromServer = await userContactAPIService.getUserContact(event.userContactId);

        if (!isObjectEmpty(userContactFromServer)) {
          yield* yieldUserContactState(userContact: userContactFromServer);
          functionCallback(event, userContactFromServer);
        }
      }
    } catch (e) {
      showToast('Failed to get User Contact. Please try again later.', Toast.LENGTH_LONG);
      functionCallback(event, null);
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
    try {
      UserContact ownUserContact = await userContactAPIService.getOwnUserContact();

      if (!isObjectEmpty(ownUserContact)) {
        userContactDBService.addUserContact(ownUserContact);
        yield* yieldUserContactState(updatedOwnUserContact: ownUserContact, userContact: ownUserContact);
        functionCallback(event, ownUserContact);
      }
    } catch (e) {
      functionCallback(event, null);
    }
  }

  /// Get a list of userContacts from server with pagination.
  Stream<UserContactState> _getUserOwnUserContactsEvent(GetUserOwnUserContactsEvent event) async* {
    try {
      int page = event.getUserOwnUserContactsRequest.pageable.page;
      int size = event.getUserOwnUserContactsRequest.pageable.size;

      List<UserContact> existingUserContacts = await userContactDBService.getAllUserContactsWithPagination(page, size);

      yield* yieldUserContactState(updatedUserContactList: existingUserContacts);

      // TODO: Get the list from backend with pagination.
      Page userContactPageResponse = await userContactAPIService.getUserContactsOfAUser(event.getUserOwnUserContactsRequest);

      List<UserContact> userContacts = userContactPageResponse.content.map((userContactRaw) => UserContact.fromJson(userContactRaw)).toList();

      userContactDBService.addUserContacts(userContacts);

      yield* yieldUserContactState(updatedUserContactList: userContacts);

      functionCallback(event, true);
    } catch (e) {
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
        userContactDBService.addUserContact(updatedUserContact);

        yield* yieldUserContactState(userContact: updatedUserContact);
      }

      functionCallback(event, updatedUserContact);
    }
  }

  Stream<UserContactState> _removeAllUserContactsEvent(RemoveAllUserContactsEvent event) async* {
    userContactDBService.deleteAllUserContacts();
    yield UserContactsNotLoaded();
    functionCallback(event, true);
  }

  Stream<UserContactState> yieldUserContactState({UserContact updatedOwnUserContact, List<UserContact> updatedUserContactList, UserContact userContact}) async* {
    UserContact existingOwnUserContact;
    List<UserContact> existingUserContactList;

    if (state is UserContactsLoaded) {
      existingOwnUserContact = (state as UserContactsLoaded).ownUserContact;
      existingUserContactList = (state as UserContactsLoaded).userContactList;

      if (!updatedOwnUserContact.isNull) {
        existingOwnUserContact = updatedOwnUserContact;

        existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == updatedOwnUserContact.id);

        existingUserContactList.add(updatedOwnUserContact);
      }

      if (!isObjectEmpty(userContact)) {
        existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == userContact.id);

        existingUserContactList.add(userContact);
      }

      if (!isObjectEmpty(updatedUserContactList)) {
        updatedUserContactList.forEach((updatedUserContact) {
          existingUserContactList.removeWhere((existingUserContact) => existingUserContact.id == updatedUserContact.id);
        });
        existingUserContactList.addAll(updatedUserContactList);
      }

      yield UserContactsLoading(); // Need change state for BlOC to detect changes.
      yield UserContactsLoaded(existingUserContactList, existingOwnUserContact);
    } else {
      yield UserContactsLoaded(updatedUserContactList, updatedOwnUserContact);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event?.callback(value);
    }
  }
}
