import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import '../RestResponseUtils.dart';

// There's a problem when connected to VPN, be careful.
class IPLocationAPIService {
  String REST_URL = globals.REST_URL;
  String IP_GEOLOCATION_API_KEY = globals.IP_GEOLOCATION_API_KEY;

  Future<IPGeoLocation> getIPGeolocation() async {
    String wholeURL =
        "https://api.ipgeolocation.io/ipgeo?apiKey=$IP_GEOLOCATION_API_KEY";
    try {
      return getIPGeoLocationBody(await http.get(wholeURL));
    } catch (e) {
      debugPrint("Error in getIPGeolocation().");
      debugPrint("Error: " + e.toString());
      return null;
    }
  }

  IPGeoLocation getIPGeoLocationBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      IPGeoLocation ipGeoLocation =
          IPGeoLocation.fromJson(json.decode(httpResponse.body));
      return ipGeoLocation;
    }
    return null;
  }
}
