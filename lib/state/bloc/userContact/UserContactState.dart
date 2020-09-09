import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class UserContactState extends Equatable {
  const UserContactState();

  @override
  List<Object> get props => [];
}

class UserContactsLoading extends UserContactState {}

class UserContactsLoaded extends UserContactState {
  final List<UserContact> userContactList;
  final UserContact ownUserContact;

  const UserContactsLoaded([this.userContactList = const [], this.ownUserContact]);

  @override
  List<Object> get props => [userContactList];

  @override
  String toString() => 'UserContactLoaded {userContactList: $userContactList, ownUserContact: $ownUserContact}';
}

class UserContactsNotLoaded extends UserContactState {}
