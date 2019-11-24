import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class UserContactState extends Equatable {
  const UserContactState();

  @override
  List<Object> get props => [];
}

class UserContactLoading extends UserContactState {}

class UserContactsLoaded extends UserContactState {
  final List<UserContact> userContactList;

  const UserContactsLoaded([this.userContactList = const []]);

  @override
  List<Object> get props => [userContactList];

  @override
  String toString() => 'UserContactLoaded {userContactList: $userContactList}';
}

class UserContactsNotLoaded extends UserContactState {}
