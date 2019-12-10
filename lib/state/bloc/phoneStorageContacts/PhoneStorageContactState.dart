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
  final List<Contact> searchResults;

  const PhoneStorageContactsLoaded([this.phoneStorageContactList = const [], this.searchResults = const []]);

  @override
  List<Object> get props => [phoneStorageContactList, searchResults];

  @override
  String toString() => 'PhoneStorageContactsLoaded {phoneStorageContactList: $phoneStorageContactList}';
}

class PhoneStorageContactsNotLoaded extends PhoneStorageContactState {}
