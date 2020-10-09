import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/database/sembast/index.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/state/bloc/user/bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoading());

  UserAPIService userAPIService = Get.find();
  UserDBService userDBService = Get.find();

  String ENVIRONMENT = globals.ENVIRONMENT;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is InitializeUserEvent) {
      yield* _initializeUser(event);
    } else if (event is EditUserEvent) {
      yield* _editUserToState(event);
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
        final FlutterSecureStorage storage = Get.find();
        String userId = await storage.read(key: 'userId');

        User userFromDB = await userDBService.getSingleUser(userId);

        if (userId.isNotEmpty && !userFromDB.isNull) {
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

  Stream<UserState> _getOwnUser(GetOwnUserEvent event) async* {
    User user = await userAPIService.getOwnUser();

    if (!user.isNull) {
      userDBService.addUser(user);
      final FlutterSecureStorage storage = Get.find();
      storage.write(key: 'userId', value: user.id);
      yield UserLoaded(user);
    }

    functionCallback(event, user);
  }

  // TODO: Moved to AuthenticationBloc
  Stream<UserState> _checkUserSignedUp(CheckUserSignedUpEvent event) async* {
    bool isSignedUp = false;
    User existingUserUsingMobileNo;
    User existingUserUsingGoogleAccount;

    if (event.mobileNo.isNotEmpty) {
//      existingUserUsingMobileNo = await userAPIService.getUserByUsingMobileNo(event.mobileNo);
    }

    if (!event.googleSignIn.isNull && event.googleSignIn.currentUser.id.isNotEmpty) {
//      existingUserUsingGoogleAccount = await userAPIService.getUserByUsingGoogleAccountId(event.googleSignIn.currentUser.id);
    }

    // Must have both not empty then only considered it as sign up
    isSignedUp = !existingUserUsingMobileNo.isNull && !existingUserUsingGoogleAccount.isNull;

    if (ENVIRONMENT != 'PRODUCTION') {
      isSignedUp = true;
    }

    functionCallback(event, isSignedUp);
  }

  // TODO: Moved to AuthenticationBloc
  Stream<UserState> _signIn(UserSignInEvent event) async* {
    bool isSignedIn = false;
    User userFromServer;
    bool saved = false;
    if (!event.googleSignIn.isNull) {
      isSignedIn = await event.googleSignIn.isSignedIn();
      if (isSignedIn) {
//        userFromServer = await userAPIService.getUserByUsingGoogleAccountId(event.googleSignIn.currentUser.id);

        if (!userFromServer.isNull) {
          // Check mobile no match with it's googleAccount ID or not.
          if (userFromServer.mobileNo == event.mobileNo) {
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

    if (!isSignedIn || userFromServer.isNull || !saved) {
      yield UserNotLoaded();
      functionCallback(event, null);
    }
  }

  Stream<UserState> _removeAllUsersEvent(RemoveAllUsersEvent event) async* {
    yield UserNotLoaded();
    functionCallback(event, true);
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
