import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/IPGeoLocation/IPGeoLocation.dart';

import '../RestResponseUtils.dart';

// There's a problem when connected to VPN, be careful.
class IPLocationAPIService {
  String REST_URL = globals.REST_URL;
  String IP_GEOLOCATION_API_KEY = globals.IP_GEOLOCATION_API_KEY;

  Future<IPGeoLocation> getIPGeolocation() async {
    String wholeURL = "https://api.ipgeolocation.io/ipgeo?apiKey=$IP_GEOLOCATION_API_KEY";

    try {
      var httpResponse = await http.get(wholeURL);

      if (httpResponseIsOK(httpResponse)) {
        print("httpResponse.body: " + httpResponse.body.toString());
        IPGeoLocation ipGeoLocation = IPGeoLocation.fromJson(json.decode(httpResponse.body));

        return ipGeoLocation;
      }
    } catch (e) {
      print("Error in getIPGeolocation().");
      print("Error: " + e.toString());
    }

    return null;
  }
}
