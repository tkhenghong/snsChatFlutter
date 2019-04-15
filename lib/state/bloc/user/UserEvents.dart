import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

//enum UserEvent { login, signOut }

abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

class UserLogin extends UserEvent {
  final GoogleSignIn googleSignIn;// For getting value from front end method call
  UserLogin({@required this.googleSignIn}) : super([googleSignIn]);

  @override
  String toString() => 'UserLogin { googleSignIn: $googleSignIn }';
}

class UserLogOut extends UserEvent {
  @override
  String toString() => 'UserLogOut';
}
