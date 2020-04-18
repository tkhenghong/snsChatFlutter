import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class SettingsAPIService {
  String REST_URL = globals.REST_URL;
  String settingsAPI = "settings";

  Future<Settings> addSettings(Settings settings) async {
    String wholeURL = "$REST_URL/$settingsAPI";
    String settingsJsonString = json.encode(settings.toJson());
    var httpResponse = await http.post("$REST_URL/$settingsAPI",
        body: settingsJsonString, headers: createAcceptJSONHeader());
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
    return httpResponseIsOK(await http.put("$REST_URL/$settingsAPI",
        body: settingsJsonString, headers: createAcceptJSONHeader()));
  }

  Future<bool> deleteSettings(String settingsId) async {
    return httpResponseIsOK(
        await http.delete("$REST_URL/$settingsAPI/$settingsId"));
  }

  Future<Settings> getSingleSettings(String settingsId) async {
    return getSettingsBody(
        await http.get("$REST_URL/$settingsAPI/$settingsId"));
  }

  Future<Settings> getSettingsOfAUser(String userId) async {
    return getSettingsBody(
        await http.get("$REST_URL/$settingsAPI/user/$userId"));
  }

  Settings getSettingsBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      Settings settings = new Settings.fromJson(json.decode(httpResponse.body));
      return settings;
    }
    return null;
  }
}
