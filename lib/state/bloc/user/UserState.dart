import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable{}

class UserInitialized extends UserState {
  @override
  String toString() => 'UserInitialized';
}

class UserLoggedIn extends UserState {
  @override
  String toString() => 'UserLoggedIn';
}

class UserLoggedOut extends UserState {
  @override
  String toString() => 'UserLoggedOut';
}