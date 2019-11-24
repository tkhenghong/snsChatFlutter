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
  UserContactState get initialState => UserContactLoading();

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
    } else if (event is SendUserContactEvent) {
      yield* _uploadUserContact(event);
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
    if (state is UserContactsLoaded) {
      List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

      existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

      existingUserContactList.add(event.userContact);

      functionCallback(event, event.userContact);
      yield UserContactsLoaded(existingUserContactList);
    }
  }

  Stream<UserContactState> _editUserContactToState(EditUserContactToStateEvent event) async* {
    if (state is UserContactsLoaded) {
      List<UserContact> existingUserContactList = (state as UserContactsLoaded).userContactList;

      existingUserContactList.removeWhere((UserContact existingUserContact) => existingUserContact.id == event.userContact.id);

      existingUserContactList.add(event.userContact);

      functionCallback(event, event.userContact);
      yield UserContactsLoaded(existingUserContactList);
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

  Stream<UserContactState> _uploadUserContact(SendUserContactEvent event) async* {

    UserContact newUserContact = await userContactAPIService.addUserContact(event.userContact);

    if (isObjectEmpty(newUserContact)) {
      functionCallback(event, false);
    }

    bool userContactSaved = await userContactDBService.addUserContact(newUserContact);

    if (!userContactSaved) {
      functionCallback(event, false);
    }

    add(AddUserContactToStateEvent(userContact: newUserContact, callback: (UserContact userContact) {}));
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
