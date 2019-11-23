import 'package:equatable/equatable.dart';

abstract class IPGeoLocationEvent extends Equatable {
  @override
  List<Object> get props => [];

  const IPGeoLocationEvent();
}

class GetIPGeoLocationEvent extends IPGeoLocationEvent {
  final Function callback;

  const GetIPGeoLocationEvent({this.callback});

  @override
  String toString() => 'GetIPGeoLocationEvent';
}
