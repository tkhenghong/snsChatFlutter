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
    } else if (event is AddUserContactEvent) {
      yield* _addUserContact(event);
    } else if (event is EditUserContactEvent) {
      yield* _editUserContact(event);
    } else if (event is DeleteUserContactEvent) {
      yield* _deleteUserContact(event);
    } else if (event is GetOwnUserContactEvent) {
      yield* _getOwnUserContact(event);
    } else if (event is GetUserPreviousUserContactsEvent) {
      yield* _getUserPreviousUserContactsEvent(event);
    } else if (event is AddMultipleUserContactEvent) {
      yield* _addMultipleUserContact(event);
    }
  }

  Stream<UserContactState> _initializeUserContactsToState(InitializeUserContactsEvent event) async* {
    try {
      List<UserContact> userContactListFromDB = await userContactDBService.getAllUserContacts();

      yield UserContactsLoaded(userContactListFromDB);

      functionCallback(event, true);
    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<UserContactState> _addUserContact(AddUserContactEvent event) async* {
    UserContact newUserContact;
    bool userContactAdded = false;

    newUserContact = await userContactAPIService.addUserContact(event.userContact);

    if (!isObjectEmpty(newUserContact)) {
      userContactAdded = await userContactDBService.addUserContact(newUserContact);
      if (userContactAdded) {
        List<UserContact> existingUserContactList = [];

        if (state is UserContactsLoaded) {
          existingUserContactList = (state as UserContactsLoaded).userContactList;
        }

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

      newUserContact = await userContactAPIService.addUserContact(userContact);

      if (!isObjectEmpty(newUserContact)) {
        userContactAdded = await userContactDBService.addUserContact(newUserContact);
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

  Stream<UserContactState> _getOwnUserContact(GetOwnUserContactEvent event) async* {
    if (!isObjectEmpty(event.user)) {
      UserContact userContactFromDB = await userContactDBService.getUserContactByUserId(event.user.id);

      functionCallback(event, userContactFromDB);
    } else {
      functionCallback(event, null);
    }
  }

  Stream<UserContactState> _getUserPreviousUserContactsEvent(GetUserPreviousUserContactsEvent event) async* {
    List<UserContact> userContactListFromServer = await userContactAPIService.getUserContactsByUserId(event.user.id);
    print('UserContactBloc.dart userContactListFromServer: ' + userContactListFromServer.toString());
    print('UserContactBloc.dart userContactListFromServer.length: ' + userContactListFromServer.length.toString());
    if (state is UserContactsLoaded) {
      List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

      if (!isObjectEmpty(userContactListFromServer) && userContactListFromServer.length > 0) {
        for (UserContact userContactFromServer in userContactListFromServer) {
          bool userContactExist =
              existingUserContactList.contains((UserContact userContactFromDB) => userContactFromDB.id == userContactFromServer.id);

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

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
