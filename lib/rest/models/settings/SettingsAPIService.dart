import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/customhttpClient/CustomHttpClient.dart';

class SettingsAPIService {
  String REST_URL = globals.REST_URL;
  String settingsAPI = "settings";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<Settings> addSettings(Settings settings) async {
    return Settings.fromJson(await httpClient.postRequest("$REST_URL/$settingsAPI", requestBody: settings));
  }

  Future<bool> editSettings(Settings settings) async {
    return await httpClient.putRequest("$REST_URL/$settingsAPI", requestBody: settings);
  }

  Future<bool> deleteSettings(String settingsId) async {
    return await httpClient.deleteRequest("$REST_URL/$settingsAPI/$settingsId");
  }

  Future<Settings> getSingleSettings(String settingsId) async {
    return Settings.fromJson(await httpClient.getRequest("$REST_URL/$settingsAPI/$settingsId"));
  }

  Future<Settings> getSettingsOfAUser(String userId) async {
    return Settings.fromJson(await httpClient.getRequest("$REST_URL/$settingsAPI/user/$userId"));
  }
}