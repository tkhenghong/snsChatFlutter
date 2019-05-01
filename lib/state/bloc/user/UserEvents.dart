import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

class UserLogin extends UserEvent {
  final String testing;
//  @override
//  String toString() => 'UserLogin';
  UserLogin({@required this.testing}) : super([testing]);
}

class UserLogOut extends UserEvent {
  @override
  String toString() => 'UserLogOut';
}
