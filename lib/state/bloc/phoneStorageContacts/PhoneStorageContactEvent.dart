import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/index.dart';

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
  String toString() => 'InitializePhoneStorageContactsEvent';
}