import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:snschat_flutter/general/enums/index.dart';
import 'package:snschat_flutter/general/functions/index.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  BehaviorSubject hasInternetConnection = BehaviorSubject<bool>();
  BehaviorSubject connectedThroughWifi = BehaviorSubject<bool>();
  BehaviorSubject connectedThroughMobileData = BehaviorSubject<bool>();
  BehaviorSubject hasLocationEnabled = BehaviorSubject<bool>();

  BehaviorSubject connectionType = BehaviorSubject<ConnectionType>();

  BehaviorSubject wifiName = BehaviorSubject<String>();
  BehaviorSubject wifiSSID = BehaviorSubject<String>();
  BehaviorSubject ipAddress = BehaviorSubject<String>();
  BehaviorSubject connectionStatus = BehaviorSubject<String>();

  String wifiFullName, wifiBSSID, wifiIP;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;

    if (isObjectEmpty(_connectivitySubscription)) {
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    }

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        this.hasInternetConnection.add(true);
        this.connectionType.add(ConnectionType.Wifi);
        this.connectedThroughWifi.add(true);
        this.connectedThroughMobileData.add(false);
        tryGetWifiName();
        tryGetWifiSSID();
        tryGetWifiIP();

        this.hasInternetConnection.add(true);
        this.wifiName.add(wifiFullName);
        this.wifiSSID.add(wifiBSSID);
        this.ipAddress.add(wifiIP);
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        this.connectionType.add(ConnectionType.MobileData);
        this.connectedThroughMobileData.add(true);
        this.connectedThroughWifi.add(false);
        this.connectionStatus.add(result.toString());
        clearSubscriptions();
        break;
      default:
        this.connectionStatus.add('Failed to get Connectivity.');
        clearSubscriptions();
        break;
    }
  }

  tryGetWifiName() async {
    try {
      if (Platform.isIOS) {
        LocationAuthorizationStatus status = await _connectivity.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _connectivity.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways || status == LocationAuthorizationStatus.authorizedWhenInUse) {
          this.hasLocationEnabled.add(true);
        }
      }

      wifiFullName = await _connectivity.getWifiName();
      this.wifiName.add(wifiName);
    } on PlatformException catch (e) {
      print(e.toString());
      wifiFullName = "Failed to get Wifi Name";
      this.wifiName.add(null);
    }
  }

  tryGetWifiSSID() async {
    try {
      if (Platform.isIOS) {
        LocationAuthorizationStatus status = await _connectivity.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _connectivity.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways || status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _connectivity.getWifiBSSID();
        } else {
          wifiBSSID = await _connectivity.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _connectivity.getWifiBSSID();
      }

      this.wifiSSID.add(wifiBSSID);
    } on PlatformException catch (e) {
      print(e.toString());
      wifiBSSID = "Failed to get Wifi BSSID";
      this.wifiSSID.add(null);
    }
  }

  tryGetWifiIP() async {
    try {
      wifiIP = await _connectivity.getWifiIP();
      this.ipAddress.add(wifiIP);
    } on PlatformException catch (e) {
      print(e.toString());
      wifiIP = "Failed to get Wifi IP";
      this.ipAddress.add(null);
    }
  }

  clearSubscriptions() {
    this.hasInternetConnection.add(false);
    this.connectionType.add(null);
    this.connectedThroughWifi.add(false);
    this.connectedThroughMobileData.add(false);
    this.hasLocationEnabled.add(false);
    this.wifiName.add(null);
    this.wifiSSID.add(null);
    this.ipAddress.add(null);
    this.connectionStatus.add(null);
  }
}
