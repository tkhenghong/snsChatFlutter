import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:snschat_flutter/service/index.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:snschat_flutter/general/enums/index.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  PermissionService permissionService = Get.find();

  RxBool hasInternetConnection = false.obs;
  RxBool connectedThroughWifi = false.obs;
  RxBool connectedThroughMobileData = false.obs;
  RxBool hasLocationEnabled = false.obs;

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

    if (_connectivitySubscription.isNull) {
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
        hasInternetConnection.value = true;
        connectionTypeInterface.add(ConnectionType.Wifi);
        connectedThroughWifi.value = true;
        connectedThroughMobileData.value = false;

        tryGetWifiName();
        tryGetWifiSSID();
        tryGetWifiIP();

        wifiName.value = wifiFullName;
        wifiSSID.value = wifiBSSID;
        ipAddress.value = wifiIP;
        break;
      case ConnectivityResult.mobile:
        connectionTypeInterface.add(ConnectionType.MobileData);
        hasInternetConnection.value = true;
        connectedThroughMobileData.value = true;
        connectedThroughWifi.value = false;
        break;
      case ConnectivityResult.none:
        connectionStatus.value = result.toString();
        clearSubscriptions();
        break;
      default:
        connectionStatus.value = 'Failed to get Connectivity.';
        clearSubscriptions();
        break;
    }
  }

  tryGetWifiName() async {
    try {
      // var wifiBSSID = await WifiInfo().getWifiBSSID();
      // var wifiIP = await WifiInfo().getWifiIP();
      // var wifiName = await WifiInfo().getWifiName();
      // bool allowed = await permissionService.requestLocationWhenInUsePermission();

      // if (Platform.isIOS) {
      //   LocationAuthorizationStatus status = await _connectivity.getLocationServiceAuthorization();
      //   if (status == LocationAuthorizationStatus.notDetermined) {
      //     status = await _connectivity.requestLocationServiceAuthorization();
      //   }
      //   if (status == LocationAuthorizationStatus.authorizedAlways || status == LocationAuthorizationStatus.authorizedWhenInUse) {
      //     hasLocationEnabled.value = true;
      //   }
      // }

      wifiFullName = await WifiInfo().getWifiName();
      wifiName.value = wifiFullName;
    } on PlatformException catch (e) {
      print(e.toString());
      wifiFullName = "Failed to get Wifi Name";
      wifiName.value = null;
    }
  }

  tryGetWifiSSID() async {
    try {
      // bool allowed = await permissionService.requestLocationWhenInUsePermission();

      // if (Platform.isIOS) {
      //   LocationAuthorizationStatus status = await _connectivity.getLocationServiceAuthorization();
      //   if (status == LocationAuthorizationStatus.notDetermined) {
      //     status = await _connectivity.requestLocationServiceAuthorization();
      //   }
      //   if (status == LocationAuthorizationStatus.authorizedAlways || status == LocationAuthorizationStatus.authorizedWhenInUse) {
      //     wifiBSSID = await _connectivity.getWifiBSSID();
      //   } else {
      //     wifiBSSID = await _connectivity.getWifiBSSID();
      //   }
      // } else {
      //   wifiBSSID = await _connectivity.getWifiBSSID();
      // }

      wifiSSID.value = await WifiInfo().getWifiBSSID();
    } on PlatformException catch (e) {
      print(e.toString());
      wifiBSSID = "Failed to get Wifi BSSID";
      wifiSSID.value = null;
    }
  }

  tryGetWifiIP() async {
    try {
      wifiIP = await WifiInfo().getWifiIP();
      ipAddress.value = wifiIP;
    } on PlatformException catch (e) {
      print(e.toString());
      wifiIP = "Failed to get Wifi IP";
      ipAddress.value = null;
    }
  }

  clearSubscriptions() {
    hasInternetConnection.value = false;
    connectionTypeInterface.add(null);
    connectedThroughWifi.value = false;
    connectedThroughMobileData.value = false;
    hasLocationEnabled.value = false;
    wifiName.value = null;
    wifiSSID.value = null;
    ipAddress.value = null;
    connectionStatus.value = null;
  }
}
