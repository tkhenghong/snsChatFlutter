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
    } else if (event is AddUserToStateEvent) {
      yield* _addUserToState(event);
    } else if (event is EditUserToStateEvent) {
      yield* _editUserToState(event);
    } else if (event is DeleteUserToStateEvent) {
      yield* _deleteUserToState(event);
    } else if (event is ChangeUserEvent) {
      yield* _changeUser(event);
    } else if (event is GetOwnUserEvent) {
      yield* _getOwnUser(event);
    }
  }

  // Require:
  // 1. GoogleSignIn: To find that user using googleSignIn unique ID
  Stream<UserState> _initializeUserToState(InitializeUserEvent event) async* {
    try {
      List<User> userListFromDB = await userDBService.getAllUsers();

      User userFromDB = await userDBService.getUserByGoogleAccountId(event.googleSignIn.currentUser.id);

      print("userFromDB.id: " + userFromDB.id.toString());

      if(!isObjectEmpty(userFromDB)) {
        yield UserLoaded(userListFromDB);
        functionCallback(event, true);
      } else {
        yield UserNotLoaded();
        functionCallback(event, false);
      }



    } catch (e) {
      functionCallback(event, false);
    }
  }

  Stream<UserState> _addUserToState(AddUserToStateEvent event) async* {
    if (state is UserLoaded) {
      List<User> existingUserList = (state as UserLoaded).userList;

      existingUserList.removeWhere((User existingUser) => existingUser.id == event.user.id);

      existingUserList.add(event.user);

      functionCallback(event, event.user);
      yield UserLoaded(existingUserList);
    }
  }

  Stream<UserState> _editUserToState(EditUserToStateEvent event) async* {
    if (state is UserLoaded) {
      List<User> existingUserList = (state as UserLoaded).userList;

      existingUserList.removeWhere((User existingUser) => existingUser.id == event.user.id);

      existingUserList.add(event.user);

      functionCallback(event, event.user);
      yield UserLoaded(existingUserList);
    }
  }

  Stream<UserState> _deleteUserToState(DeleteUserToStateEvent event) async* {
    if (state is UserLoaded) {
      List<User> existingUserList = (state as UserLoaded).userList;

      existingUserList.removeWhere((User existingUser) => existingUser.id == event.user.id);

      functionCallback(event, true);
      yield UserLoaded(existingUserList);
    }
  }

  Stream<UserState> _changeUser(ChangeUserEvent event) async* {

    User newUser = await userAPIService.addUser(event.user);

    if (isObjectEmpty(newUser)) {
      functionCallback(event, false);
    }

    bool userSaved = await userDBService.addUser(newUser);

    if (!userSaved) {
      functionCallback(event, false);
    }

    add(AddUserToStateEvent(user: newUser, callback: (User user) {}));
  }

  // GetOwnUserEvent
  Stream<UserState> _getOwnUser(GetOwnUserEvent event) async* {
    if (state is UserLoaded) {
      // TODO: Probably need sending info from
      // GetOwnGoogleInfoEvent
      (state as GoogleInfoState).props.add(GetOwnGoogleInfoEvent((GoogleSignIn googleSignIn, FirebaseAuth firebaseAuth, FirebaseUser firebaseUser) {

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
