import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

// Unable to get location when connected to a VPN.
class IPLocationAPIService {
  String REST_URL = globals.REST_URL;
  String IP_GEOLOCATION_API_KEY = globals.IP_GEOLOCATION_API_KEY;
  String IP_GEO_LOCATION_HOST_ADDRESS = globals.IP_GEO_LOCATION_HOST_ADDRESS;

  CustomHttpClient httpClient = Get.find();

  Future<IPGeoLocation> getIPGeolocation() async {
    return IPGeoLocation.fromJson(await httpClient.getRequest("https://$IP_GEO_LOCATION_HOST_ADDRESS/ipgeo?apiKey=$IP_GEOLOCATION_API_KEY", timeoutSeconds: 5));
  }
}
