import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';

import 'bloc.dart';

class IPGeoLocationBloc extends Bloc<IPGeoLocationEvent, IPGeoLocationState> {
  IPLocationAPIService ipLocationAPIService = IPLocationAPIService();

  @override
  get initialState => IPGeoLocationLoading();

  @override
  Stream<IPGeoLocationState> mapEventToState(event) async* {
    // TODO: implement mapEventToState
    if(event is InitializeIPGeoLocationEvent) {
      yield* _initIPGeoLocationToState(event);
    } else if (event is GetIPGeoLocationEvent) {
      yield* _mapIPGeoLocationToState(event);
    }
  }

  // InitializeIPGeoLocationEvent
  Stream<IPGeoLocationState> _initIPGeoLocationToState(InitializeIPGeoLocationEvent event) async* {
    IPGeoLocation ipGeoLocation = await ipLocationAPIService.getIPGeolocation();

    if (!isObjectEmpty(ipGeoLocation)) {
      yield IPGeoLocationLoaded(ipGeoLocation);
      functionCallback(event, true);
    } else {
      yield IPGeoLocationNotLoaded();
      functionCallback(event, false);
    }
  }

  Stream<IPGeoLocationState> _mapIPGeoLocationToState(GetIPGeoLocationEvent event) async* {

    if(state is IPGeoLocationLoaded) {
      IPGeoLocation ipGeoLocation = (state as IPGeoLocationLoaded).ipGeoLocation;
      functionCallback(event, ipGeoLocation);
    } else {
      functionCallback(event, null);
    }
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
