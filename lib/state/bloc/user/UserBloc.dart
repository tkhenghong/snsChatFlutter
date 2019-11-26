import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      User userFromDB = await userDBService.getUserByGoogleAccountId(event.googleSignIn.currentUser.id);

      print("userFromDB.id: " + userFromDB.id.toString());

      if (!isObjectEmpty(userFromDB)) {
        yield UserLoaded(userFromDB);
        functionCallback(event, true);
      } else {
        yield UserNotLoaded();
        functionCallback(event, false);
      }
    } catch (e) {
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
    if (state is UserLoaded) {
      bool updatedInREST = await userAPIService.editUser(event.user);

      if (!updatedInREST) {
        functionCallback(event, null);
      }

      bool userSaved = await userDBService.editUser(event.user);

      if (!userSaved) {
        functionCallback(event, null);
      }

      functionCallback(event, event.user);
      yield UserLoaded(event.user);
    }
  }

  // Remove User from DB, and BLOC state
  Stream<UserState> _deleteUserFromState(DeleteUserFromStateEvent event) async* {
    if (state is UserLoaded) {
      bool userDeleted = await userDBService.deleteUser(event.user.id);

      if (!userDeleted) {
        functionCallback(event, false);
      }

      functionCallback(event, true);
      yield UserNotLoaded();
    }
  }

  Stream<UserState> _getOwnUser(GetOwnUserEvent event) async* {
    if (state is UserLoaded) {
      User user = (state as UserLoaded).user;
      functionCallback(event, user);
      (state as GoogleInfoState).props
          .add(GetOwnGoogleInfoEvent((GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth, FirebaseUser firebaseUser) {
        print('Experiment: see whether can get another BLOC\'s data when inside a BLOC');
      }));
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
