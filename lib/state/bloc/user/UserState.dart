import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> userList;

  const UserLoaded([this.userList = const []]);

  @override
  List<Object> get props => [userList];

  @override
  String toString() => 'UserLoaded {userList: $userList}';
}

class UserNotLoaded extends UserState {}
