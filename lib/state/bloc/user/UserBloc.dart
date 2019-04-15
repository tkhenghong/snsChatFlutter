import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/state/bloc/user/UserEvents.dart';
import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/state/bloc/user/UserState.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  // Current app states are here
  GoogleSignIn googleSignIn;


  @override
  // TODO: implement initialState
  get initialState => null;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* { // Like reducer
    // TODO: implement mapEventToState
    print('UserBloc.dart mapEventToState()');
  if(event is UserLogin) {
    print('event is UserLogin');

    googleSignIn = event.googleSignIn;
    yield UserLoggedIn();
  }

  if(event is UserLogOut) {
    yield UserLoggedOut();
  }
  }
}

