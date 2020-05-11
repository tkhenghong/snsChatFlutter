import 'package:equatable/equatable.dart';
import 'package:snschat_flutter/objects/models/index.dart';

abstract class IPGeoLocationState extends Equatable {
  const IPGeoLocationState();

  @override
  List<Object> get props => [];
}

class IPGeoLocationLoading extends IPGeoLocationState {}

class IPGeoLocationLoaded extends IPGeoLocationState {
  final IPGeoLocation ipGeoLocation;

  const IPGeoLocationLoaded([this.ipGeoLocation]);

  @override
  List<Object> get props => [ipGeoLocation];

  @override
  String toString() => 'IPGeoLocationLoaded {ipGeoLocation: $ipGeoLocation}';
}

class IPGeoLocationNotLoaded extends IPGeoLocationState {}
