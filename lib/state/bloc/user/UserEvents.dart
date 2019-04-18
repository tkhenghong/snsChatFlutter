import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

class UserLogin extends UserEvent {
  @override
  String toString() => 'UserLogin';
}

class UserLogOut extends UserEvent {
  @override
  String toString() => 'UserLogOut';
}
