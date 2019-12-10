import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

abstract class PhoneStorageContactState extends Equatable {
  const PhoneStorageContactState();

  @override
  List<Object> get props => [];
}

class PhoneStorageContactLoading extends PhoneStorageContactState {}

class PhoneStorageContactsLoaded extends PhoneStorageContactState {
  final List<Contact> phoneStorageContactList;

  const PhoneStorageContactsLoaded([this.phoneStorageContactList = const []]);

  @override
  List<Object> get props => [phoneStorageContactList];

  @override
  String toString() => 'PhoneStorageContactsLoaded {phoneStorageContactList: $phoneStorageContactList}';
}

class PhoneStorageContactsNotLoaded extends PhoneStorageContactState {}
