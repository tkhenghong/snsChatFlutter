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

        bool hasInternetConnection = await networkService.hasInternetConnection.last;

        if (!hasInternetConnection) {
          yield NetworkNotLoaded();
          functionCallback(event, false);
        } else {
          String connectionStatus = await networkService.connectionStatus.last;
          String wifiName = await networkService.wifiName.last;
          String wifiSSID = await networkService.wifiSSID.last;
          String wifiIP = await networkService.ipAddress.last;
          bool connectedThroughWifi = await networkService.connectedThroughWifi.last;
          bool connectedThroughMobileData = await networkService.connectedThroughMobileData.last;

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
