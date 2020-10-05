import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:snschat_flutter/general/enums/index.dart';
import 'package:snschat_flutter/general/functions/index.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  RxBool hasInternetConnection = false.obs;
  RxBool connectedThroughWifi = false.obs;
  RxBool connectedThroughMobileData = false.obs;
  RxBool hasLocationEnabled = false.obs;

//  RxInterface<ConnectionType> connectionTypeInterface = null.obs;
  final connectionTypeInterface = BehaviorSubject<ConnectionType>();

  RxString wifiName = ''.obs;
  RxString wifiSSID = ''.obs;
  RxString ipAddress = ''.obs;
  RxString connectionStatus = ''.obs;

  String wifiFullName, wifiBSSID, wifiIP;

  NetworkService() {
    initConnectivity();
  }

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
//        hasInternetConnection.add(true);
        hasInternetConnection.value = true;
//        connectionTypeInterface.subject.add(ConnectionType.Wifi);
        connectionTypeInterface.add(ConnectionType.Wifi);
//        connectedThroughWifi.add(true);
        connectedThroughWifi.value = true;
//        connectedThroughMobileData.add(false);
        connectedThroughMobileData.value = false;

        tryGetWifiName();
        tryGetWifiSSID();
        tryGetWifiIP();

//        wifiName.add(wifiFullName);
        wifiName.value = wifiFullName;
//        wifiSSID.add(wifiBSSID);
        wifiSSID.value = wifiBSSID;
//        ipAddress.add(wifiIP);
        ipAddress.value = wifiIP;
        break;
      case ConnectivityResult.mobile:
//        connectionType.add(ConnectionType.MobileData);
        connectionTypeInterface.add(ConnectionType.MobileData);
//        hasInternetConnection.add(true);
        hasInternetConnection.value = true;
//        connectedThroughMobileData.add(true);
        connectedThroughMobileData.value = true;
//        connectedThroughWifi.add(false);
        connectedThroughWifi.value = false;
        break;
      case ConnectivityResult.none:
//        connectionStatus.add(result.toString());
        connectionStatus.value = result.toString();
        clearSubscriptions();
        break;
      default:
//        connectionStatus.add('Failed to get Connectivity.');
        connectionStatus.value = 'Failed to get Connectivity.';
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
//          hasLocationEnabled.add(true);
          hasLocationEnabled.value = true;
        }
      }

      wifiFullName = await _connectivity.getWifiName();
//      wifiName.add(wifiFullName);
      wifiName.value = wifiFullName;
    } on PlatformException catch (e) {
      print(e.toString());
      wifiFullName = "Failed to get Wifi Name";
//      wifiName.add(null);
      wifiName.value = null;
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

//      wifiSSID.add(wifiBSSID);
      wifiSSID.value = wifiBSSID;
    } on PlatformException catch (e) {
      print(e.toString());
      wifiBSSID = "Failed to get Wifi BSSID";
//      wifiSSID.add(null);
      wifiSSID.value = null;
    }
  }

  tryGetWifiIP() async {
    try {
      wifiIP = await _connectivity.getWifiIP();
//      ipAddress.add(wifiIP);
      ipAddress.value = wifiIP;
    } on PlatformException catch (e) {
      print(e.toString());
      wifiIP = "Failed to get Wifi IP";
//      ipAddress.add(null);
      ipAddress.value = null;
    }
  }

  clearSubscriptions() {
//    hasInternetConnection.add(false);
    hasInternetConnection.value = false;
//    connectionType.add(null);
//    connectionTypeInterface.subject.add(null);
    connectionTypeInterface.add(null);
//    connectedThroughWifi.add(false);
    connectedThroughWifi.value = false;
//    connectedThroughMobileData.add(false);
    connectedThroughMobileData.value = false;
//    hasLocationEnabled.add(false);
    hasLocationEnabled.value = false;
//    wifiName.add(null);
    wifiName.value = null;
//    wifiSSID.add(null);
    wifiSSID.value = null;
//    ipAddress.add(null);
    ipAddress.value = null;
//    connectionStatus.add(null);
    connectionStatus.value = null;
  }
}
