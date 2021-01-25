import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class SettingsAPIService {
  EnvironmentGlobalVariables env = Get.find();
  String settingsAPI = "settings";

  CustomHttpClient httpClient = Get.find();

  Future<bool> editSettings(UpdateSettingsRequest updateSettingsRequest) async {
    return await httpClient.putRequest("${env.REST_URL}/$settingsAPI", requestBody: updateSettingsRequest);
  }

  Future<Settings> getUserOwnSettings() async {
    return Settings.fromJson(await httpClient.getRequest("${env.REST_URL}/$settingsAPI/user"));
  }
}
