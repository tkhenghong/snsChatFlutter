import 'package:equatable/equatable.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object> get props => [];
}

class NetworkLoading extends NetworkState {}

class NetworkLoaded extends NetworkState {
  final String connectionStatus;
  final String wifiName;
  final String wifiSSID;
  final String ipAddress;
  final bool connectedUsingWifi;
  final bool connectedUsingMobileData;

  const NetworkLoaded([this.connectionStatus, this.wifiName, this.wifiSSID, this.ipAddress, this.connectedUsingWifi, this.connectedUsingMobileData]);

  @override
  List<Object> get props => [connectionStatus, wifiName, wifiSSID, ipAddress, connectedUsingWifi, connectedUsingMobileData];

  @override
  String toString() => 'NetworkLoaded {connectionStatus: $connectionStatus, wifiName: $wifiName, wifiSSID: $wifiSSID, ipAddress: $ipAddress, connectedUsingWifi: $connectedUsingWifi, connectedUsingMobileData: $connectedUsingMobileData}';
}

class NetworkNotLoaded extends NetworkState {
  final String connectionStatus;
  final String wifiName;
  final String wifiSSID;
  final String ipAddress;
  final bool connectedUsingWifi;
  final bool connectedUsingMobileData;

  const NetworkNotLoaded([this.connectionStatus, this.wifiName, this.wifiSSID, this.ipAddress, this.connectedUsingWifi, this.connectedUsingMobileData]);

  @override
  List<Object> get props => [connectionStatus, wifiName, wifiSSID, ipAddress, connectedUsingWifi, connectedUsingMobileData];

  @override
  String toString() => 'NetworkNotLoaded {connectionStatus: $connectionStatus, wifiName: $wifiName, wifiSSID: $wifiSSID, ipAddress: $ipAddress, connectedUsingWifi: $connectedUsingWifi, connectedUsingMobileData: $connectedUsingMobileData}';
}
