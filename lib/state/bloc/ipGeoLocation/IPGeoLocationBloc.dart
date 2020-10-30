import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/index.dart';

import 'bloc.dart';

class IPGeoLocationBloc extends Bloc<IPGeoLocationEvent, IPGeoLocationState> {
  IPGeoLocationBloc() : super(IPGeoLocationLoading());

  IPLocationAPIService ipLocationAPIService = Get.find();

  @override
  Stream<IPGeoLocationState> mapEventToState(event) async* {
    if (event is InitializeIPGeoLocationEvent) {
      yield* _initIPGeoLocationToState(event);
    }
  }

  Stream<IPGeoLocationState> _initIPGeoLocationToState(InitializeIPGeoLocationEvent event) async* {
    IPGeoLocation ipGeoLocation;
    try {
      ipGeoLocation = await ipLocationAPIService.getIPGeolocation();
    } on TimeoutException {
      yield IPGeoLocationNotLoaded();
      functionCallback(event, false);
      throw NetworkTimeoutException('Get IP Location', 'Unable to get your location in time.');
    }

    if (!ipGeoLocation.isNull) {
      yield IPGeoLocationLoaded(ipGeoLocation);
      functionCallback(event, true);
    } else {
      yield IPGeoLocationNotLoaded();
      functionCallback(event, false);
    }
  }

  void functionCallback(event, value) {
    if (!isObjectEmpty(event)) {
      event.callback(value);
    }
  }
}
