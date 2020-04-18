import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/user/bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserAPIService userAPIService = UserAPIService();
  UserDBService userDBService = UserDBService();

  @override
  UserState get initialState => UserLoading();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is InitializeUserEvent) {
      yield* _initializeUser(event);
    } else if (event is AddUserEvent) {
      yield* _addUser(event);
    } else if (event is EditUserEvent) {
      yield* _editUserToState(event);
    } else if (event is DeleteUserEvent) {
      yield* _deleteUserFromState(event);
    } else if (event is GetOwnUserEvent) {
      yield* _getOwnUser(event);
    } else if (event is CheckUserSignedUpEvent) {
      yield* _checkUserSignedUp(event);
    } else if (event is UserSignInEvent) {
      yield* _signIn(event);
    }
  }

  Stream<UserState> _initializeUser(InitializeUserEvent event) async* {
    if (state is UserLoading || state is UserNotLoaded) {
      try {
        User userFromDB = await userDBService.getUserByGoogleAccountId(event.googleSignIn.currentUser.id);

        if (!isObjectEmpty(userFromDB)) {
          yield UserLoaded(userFromDB);
          functionCallback(event, true);
        } else {
          yield UserNotLoaded();
          functionCallback(event, false);
        }
      } catch (e) {
        yield UserNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  // Register user in API, DB, BLOC
  Stream<UserState> _addUser(AddUserEvent event) async* {
    User userFromServer;
    bool userSaved = false;

    // Avoid readding existed user object
    if(isStringEmpty(event.user.id)) {
      userFromServer = await userAPIService.addUser(event.user);
    } else {
      userFromServer = event.user;
    }

    if (!isObjectEmpty(userFromServer)) {
      userSaved = await userDBService.addUser(userFromServer);

      if (userSaved) {
        yield UserLoaded(userFromServer);
        functionCallback(event, userFromServer);
      }
    }

    if (isObjectEmpty(userFromServer) || !userSaved) {
      yield UserNotLoaded();
      functionCallback(event, null);
    }
  }

  // Change User information in API, DB, and State
  Stream<UserState> _editUserToState(EditUserEvent event) async* {
    bool updatedInREST = false;
    bool userSaved = false;
    if (state is UserLoaded) {
      updatedInREST = await userAPIService.editUser(event.user);

      if (updatedInREST) {
        userSaved = await userDBService.editUser(event.user);

        if (userSaved) {
          yield UserLoaded(event.user);
          functionCallback(event, event.user);
        }
      }
    }

    if (!updatedInREST || !userSaved) {
      functionCallback(event, null);
    }
  }

  // Remove User from DB, and BLOC state
  Stream<UserState> _deleteUserFromState(DeleteUserEvent event) async* {
    bool deletedFromREST = false;
    bool deleted = false;
    if (state is UserLoaded) {
      deletedFromREST = await userAPIService.deleteUser(event.user.id);
      if (deletedFromREST) {
        deleted = await userDBService.deleteUser(event.user.id);
        if (deleted) {
          functionCallback(event, true);

          User existingUser = (state as UserLoaded).user;

          if (existingUser.id == event.user.id) {
            yield UserNotLoaded();
          }
        }
      }

      if (!deletedFromREST || !deleted) {
        functionCallback(event, false);
      }
    }
  }

  Stream<UserState> _getOwnUser(GetOwnUserEvent event) async* {
    if (state is UserLoaded) {
      User user = (state as UserLoaded).user;
      functionCallback(event, user);
    }
  }

  Stream<UserState> _checkUserSignedUp(CheckUserSignedUpEvent event) async* {
    bool isSignedUp = false;
    User existingUserUsingMobileNo;
    User existingUserUsingGoogleAccount;

    if (!isStringEmpty(event.mobileNo)) {
      existingUserUsingMobileNo = await userAPIService.getUserByUsingMobileNo(event.mobileNo);
    }

    if (!isObjectEmpty(event.googleSignIn) && !isStringEmpty(event.googleSignIn.currentUser.id)) {
      existingUserUsingGoogleAccount = await userAPIService.getUserByUsingGoogleAccountId(event.googleSignIn.currentUser.id);
    }

    // Must have both not empty then only considered it as sign up
    isSignedUp = !isObjectEmpty(existingUserUsingMobileNo) && !isObjectEmpty(existingUserUsingGoogleAccount);

    if (!isObjectEmpty(event)) {
      event.callback(isSignedUp);
    }
  }

  Stream<UserState> _signIn(UserSignInEvent event) async* {
    bool isSignedIn = false;
    User userFromServer;
    bool saved = false;
    if (!isObjectEmpty(event.googleSignIn)) {
      isSignedIn = await event.googleSignIn.isSignedIn();
      if (isSignedIn) {
        userFromServer = await userAPIService.getUserByUsingGoogleAccountId(event.googleSignIn.currentUser.id);


        if (!isObjectEmpty(userFromServer)) {
          // Check mobile no match with it's googleAccount ID or not.
          if(userFromServer.mobileNo == event.mobileNo) {
            saved = await userDBService.addUser(userFromServer);

            if (saved) {
              yield UserLoaded(userFromServer);
              functionCallback(event, userFromServer);
            }
          } else {
            yield UserNotLoaded();
            functionCallback(event, null);
          }
        }
      }
    }

    if (!isSignedIn || isObjectEmpty(userFromServer) || !saved) {
      yield UserNotLoaded();
      functionCallback(event, null);
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
