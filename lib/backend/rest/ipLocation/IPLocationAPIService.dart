import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/IPGeoLocation/IPGeoLocation.dart';

import '../RestResponseUtils.dart';

class IPLocationAPIService {
  String REST_URL = globals.REST_URL;
  String IP_GEOLOCATION_API_KEY = globals.IP_GEOLOCATION_API_KEY;

  Future<IPGeoLocation> getIPGeolocation() async {

    String wholeURL = "https://api.ipgeolocation.io/ipgeo?apiKey=$IP_GEOLOCATION_API_KEY";

    var httpResponse = await http.get(wholeURL);

    if (httpResponseIsOK(httpResponse)) {
      print("httpResponse.body: " + httpResponse.body.toString());
      IPGeoLocation ipGeoLocation = IPGeoLocation.fromJson(json.decode(httpResponse.body));

      return ipGeoLocation;
    }
    return null;
  }
}
