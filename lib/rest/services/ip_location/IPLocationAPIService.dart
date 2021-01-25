import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

// Unable to get location when connected to a VPN.
class IPLocationAPIService {
  EnvironmentGlobalVariables env = Get.find();

  CustomHttpClient httpClient = Get.find();

  Future<IPGeoLocation> getIPGeolocation() async {
    return IPGeoLocation.fromJson(await httpClient.getRequest("https://${env.IP_GEO_LOCATION_HOST_ADDRESS}/ipgeo?apiKey=${env.IP_GEOLOCATION_API_KEY}", timeoutSeconds: 5));
  }
}
