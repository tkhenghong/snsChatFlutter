import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/state/bloc/google/bloc.dart';
import 'package:snschat_flutter/state/bloc/user/bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {

  UserAPIService userAPIService = UserAPIService();
  UserDBService userDBService = UserDBService();

  @override
  UserState get initialState => UserLoading();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is InitializeUserEvent) {
      yield* _initializeUserToState(event);
    } else if (event is AddUserEvent) {
      yield* _addUser(event);
    } else if (event is EditUserToStateEvent) {
      yield* _editUserToState(event);
    } else if (event is DeleteUserFromStateEvent) {
      yield* _deleteUserFromState(event);
    } else if (event is GetOwnUserEvent) {
      yield* _getOwnUser(event);
    }
  }

  Stream<UserState> _initializeUserToState(InitializeUserEvent event) async* {
    try {
      // Bloc-to-bloc communication. https://bloclibrary.dev/#/architecture

      print('event.googleSignIn.currentUser.id: ' + event.googleSignIn.currentUser.id.toString());
      User userFromDB = await userDBService.getUserByGoogleAccountId(event.googleSignIn.currentUser.id);

      if (!isObjectEmpty(userFromDB)) {
        print('UserBloc.dart if (!isObjectEmpty(userFromDB))');
        print('UserBloc.dart userFromDB' + userFromDB.toString());
        yield UserLoaded(userFromDB);
        functionCallback(event, true);
      } else {
        print('UserBloc.dart if (isObjectEmpty(userFromDB))');
        yield UserNotLoaded();
        functionCallback(event, false);
      }
    } catch (e) {
      yield UserNotLoaded();
      functionCallback(event, false);
    }
  }

  // Register user in API, DB, BLOC
  Stream<UserState> _addUser(AddUserEvent event) async* {
    if (state is UserLoaded) {
      User userFromServer = await userAPIService.addUser(event.user);

      if (isObjectEmpty(userFromServer)) {
        functionCallback(event, null);
      }

      bool userSaved = await userDBService.addUser(userFromServer);

      if (!userSaved) {
        functionCallback(event, null);
      }

      functionCallback(event, userFromServer);
      yield UserLoaded(userFromServer);
    }
  }

  // Change User information in API, DB, and State
  Stream<UserState> _editUserToState(EditUserToStateEvent event) async* {
    bool updatedInREST = false;
    bool userSaved = false;
    if (state is UserLoaded) {
      updatedInREST = await userAPIService.editUser(event.user);

      if (updatedInREST) {
        userSaved = await userDBService.editUser(event.user);

        if (userSaved) {
          functionCallback(event, event.user);
          yield UserLoaded(event.user);
        }
      }
    }

    if (!updatedInREST || !userSaved) {
      functionCallback(event, null);
    }
  }

  // Remove User from DB, and BLOC state
  Stream<UserState> _deleteUserFromState(DeleteUserFromStateEvent event) async* {
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

      if(!deletedFromREST || !deleted) {
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
