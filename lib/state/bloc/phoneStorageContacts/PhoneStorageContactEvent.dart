import 'package:equatable/equatable.dart';

abstract class PhoneStorageContactEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

  const PhoneStorageContactEvent();
}

class GetPhoneStorageContactsEvent extends PhoneStorageContactEvent {
  final Function callback;

  const GetPhoneStorageContactsEvent({this.callback});

  @override
  String toString() => 'GetPhoneStorageContactsEvent';
}

// SearchPhoneStorageContactEvent
class SearchPhoneStorageContactEvent extends PhoneStorageContactEvent {
  final String searchTerm;
  final Function callback;

  const SearchPhoneStorageContactEvent({this.searchTerm, this.callback});

  @override
  String toString() => 'SearchPhoneStorageContactEvent - searchTerm: ${searchTerm}';
}