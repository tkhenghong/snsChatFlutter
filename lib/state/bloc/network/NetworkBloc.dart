import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/service/index.dart';

import 'bloc.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  PermissionService permissionService = PermissionService();
  NetworkService networkService = NetworkService();

  @override
  NetworkState get initialState => NetworkLoading();

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

        bool hasInternetConnection = await networkService.hasInternetConnection.value;

        if (!hasInternetConnection) {
          yield NetworkNotLoaded();
          functionCallback(event, false);
        } else {
          String connectionStatus = await networkService.connectionStatus.value;
          String wifiName = await networkService.wifiName.value;
          String wifiSSID = await networkService.wifiSSID.value;
          String wifiIP = await networkService.ipAddress.value;
          bool connectedThroughWifi = await networkService.connectedThroughWifi.value;
          bool connectedThroughMobileData = await networkService.connectedThroughMobileData.value;

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
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
