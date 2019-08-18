import 'dart:async';

import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/settings/settings.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class SettingsAPIService {
  String REST_URL = globals.REST_URL;

  Future<Settings> addSettings(Settings settings) async {
    String wholeURL = REST_URL + "/settings";
    String settingsJsonString = json.encode(settings.toJson());
    var httpResponse = await http.post(REST_URL + "/settings", body: settingsJsonString, headers: createAcceptJSONHeader());
    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String settingsId = locationString.replaceAll(wholeURL + "/", "");
      settings.id = settingsId;
      return settings;
    }
    return null;
  }

  Future<bool> editSettings(Settings settings) async {
    String settingsJsonString = json.encode(settings.toJson());
    var httpResponse = await http.put(REST_URL + "/settings", body: settingsJsonString, headers: createAcceptJSONHeader());
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteSettings(String settingsId) async {
    var httpResponse = await http.delete(REST_URL + "/settings/" + settingsId);
    return httpResponseIsOK(httpResponse);
  }

  Future<Settings> getSingleSettings(String settingsId) async {
    var httpResponse = await http.get(REST_URL + "/settings/" + settingsId);
    if (httpResponseIsOK(httpResponse)) {
      Settings settings = new Settings.fromJson(json.decode(httpResponse.body));
      return settings;
    }
    return null;
  }

  Future<Settings> getSettingsOfAUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/settings/user/" + userId);
    if (httpResponseIsOK(httpResponse)) {
      Settings settings = new Settings.fromJson(json.decode(httpResponse.body));
      return settings;
    }
    return null;
  }
}
