import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded([this.user]);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserLoaded {user: $user}';
}

class UserNotLoaded extends UserState {}
