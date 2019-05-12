abstract class WholeAppEvent {}

class UserSignInEvent extends WholeAppEvent {
  Function callback;

  UserSignInEvent({this.callback});
}

class UserSignOutEvent extends WholeAppEvent {}