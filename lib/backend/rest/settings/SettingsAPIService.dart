import 'dart:async';

import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/objects/settings/settings.dart';

import '../RestResponseUtils.dart';

class SettingsAPIService {
  String REST_URL = globals.REST_URL;

  Future<String> addSettings(Settings settings) async {
    var httpResponse =
        await http.post(REST_URL + "/settings", body: settings);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      var newSettingsId = jsonResponse['id'];
      print("newSettingsId: " + newSettingsId);
      settings.id = newSettingsId;
      return settings.id;
    }
    Fluttertoast.showToast(
        msg: 'Unable to create a new settings.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }

  Future<bool> editSettings(Settings settings) async {
    var httpResponse =
    await http.put(REST_URL + "/settings", body: settings);
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteSettings(Settings settings) async {
    var httpResponse =
        await http.delete(REST_URL + "/settings" + settings.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<Settings> getSettingsOfAUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/settings/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      Settings settings = convert.jsonDecode(jsonResponse);
      print("settings: " + settings.id);

      return settings;
    }
    Fluttertoast.showToast(
        msg: 'Unable to get settings for this user.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }
}
