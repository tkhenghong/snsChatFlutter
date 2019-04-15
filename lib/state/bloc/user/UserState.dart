import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable{}

class UserLoggedIn extends UserState {
  @override
  String toString() => 'UserLoggedIn';
}

class UserLoggedOut extends UserState {
  @override
  String toString() => 'UserLoggedOut';
}