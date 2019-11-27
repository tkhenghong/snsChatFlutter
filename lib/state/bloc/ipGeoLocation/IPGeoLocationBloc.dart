import 'package:bloc/bloc.dart';
import 'package:snschat_flutter/backend/rest/index.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';

import 'bloc.dart';

class IPGeoLocationBloc extends Bloc<IPGeoLocationEvent, IPGeoLocationState> {
  IPLocationAPIService ipLocationAPIService = IPLocationAPIService();

  @override
  get initialState => IPGeoLocationNotLoaded();

  @override
  Stream<IPGeoLocationState> mapEventToState(event) async* {
    // TODO: implement mapEventToState
    if (event is GetIPGeoLocationEvent) {
      yield* _mapIPGeoLocationToState(event);
    }
  }

  Stream<IPGeoLocationState> _mapIPGeoLocationToState(GetIPGeoLocationEvent event) async* {
    IPGeoLocation ipGeoLocation = await ipLocationAPIService.getIPGeolocation();

    if (!isObjectEmpty(ipGeoLocation)) {
      functionCallback(event, ipGeoLocation);
      yield IPGeoLocationLoaded(ipGeoLocation);
    } else {
      functionCallback(event, null);
      yield IPGeoLocationNotLoaded();
    }
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
