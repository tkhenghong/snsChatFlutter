import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/service/index.dart';

import 'bloc.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {

  NetworkBloc() : super(NetworkLoading());

  PermissionService permissionService = Get.find();
  NetworkService networkService = Get.find();

  @override
  Stream<NetworkState> mapEventToState(NetworkEvent event) async* {
    if (event is CheckNetworkEvent) {
      yield* _checkNetworkToState(event);
    }
  }

  Stream<NetworkState> _checkNetworkToState(CheckNetworkEvent event) async* {
    if (state is NetworkLoading || state is NetworkNotLoaded) {
      try {
        await networkService.initConnectivity();

        bool hasInternetConnection = networkService.hasInternetConnection.value;

        if (!hasInternetConnection) {
          yield NetworkNotLoaded();
          functionCallback(event, false);
        } else {
          String connectionStatus = networkService.connectionStatus.value;
          String wifiName = networkService.wifiName.value;
          String wifiSSID = networkService.wifiSSID.value;
          String wifiIP = networkService.ipAddress.value;
          bool connectedThroughWifi = networkService.connectedThroughWifi.value;
          bool connectedThroughMobileData = networkService.connectedThroughMobileData.value;

          yield NetworkLoaded(connectionStatus, wifiName, wifiSSID, wifiIP, connectedThroughWifi, connectedThroughMobileData);
          functionCallback(event, true);
        }
      } catch (e) {
        yield NetworkNotLoaded();
        functionCallback(event, false);
      }
    }
  }

  // To send response to those dispatched Actions
  void functionCallback(event, value) {
    if (!event.isNull) {
      event?.callback(value);
    }
  }
}
