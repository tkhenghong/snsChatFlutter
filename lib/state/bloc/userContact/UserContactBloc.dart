import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/userContact/bloc.dart';

class UserContactBloc extends Bloc<UserContactEvent, UserContactState> {
  UserContactAPIService userContactAPIService = UserContactAPIService();
  UserContactDBService userContactDBService = UserContactDBService();

  @override
  UserContactState get initialState => UserContactsLoading();

  @override
  Stream<UserContactState> mapEventToState(UserContactEvent event) async* {
    if (event is InitializeUserContactsEvent) {
      yield* _initializeUserContactsToState(event);
    } else if (event is AddUserContactToStateEvent) {
      yield* _addUserContactToState(event);
    } else if (event is EditUserContactToStateEvent) {
      yield* _editUserContactToState(event);
    } else if (event is DeleteUserContactToStateEvent) {
      yield* _deleteUserContactToState(event);
    } else if (event is GetOwnUserContactEvent) {
      yield* _getOwnUserContact(event);
    }
  }

  Stream<UserContactState> _initializeUserContactsToState(InitializeUserContactsEvent event) async* {
    try {
      List<UserContact> userContactListFromDB = await userContactDBService.getAllUserContacts();

      print("userContactListFromDB.length: " + userContactListFromDB.length.toString());

      yield UserContactsLoaded(userContactListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<UserContactState> _addUserContactToState(AddUserContactToStateEvent event) async* {
    UserContact newUserContact;
    bool userContactAdded;
    if (state is UserContactsLoaded) {
      UserContact newUserContact = await userContactAPIService.addUserContact(event.userContact);

      if (!isObjectEmpty(newUserContact)) {
        bool userContactAdded = await userContactDBService.addUserContact(newUserContact);
        if (userContactAdded) {
          List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

          existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

          existingUserContactList.add(event.userContact);

          functionCallback(event, event.userContact);
          yield UserContactsLoaded(existingUserContactList);
        }
      }
    }

    if (isObjectEmpty(newUserContact) || !userContactAdded) {
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _editUserContactToState(EditUserContactToStateEvent event) async* {
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

          functionCallback(event, event.userContact);
          yield UserContactsLoaded(existingUserContactList);
        }
      }
    }

    if (!updatedInREST || !userContactEdited) {
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _deleteUserContactToState(DeleteUserContactToStateEvent event) async* {
    if (state is UserContactsLoaded) {
      List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

      existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

      functionCallback(event, true);
      yield UserContactsLoaded(existingUserContactList);
    }
  }

  Stream<UserContactState> _getOwnUserContact(GetOwnUserContactEvent event) async* {
    if (!isObjectEmpty(event.user)) {
      UserContact userContactFromDB = await userContactDBService.getUserContactByUserId(event.user.id);

      functionCallback(event, userContactFromDB);
    } else {
      functionCallback(event, null);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
