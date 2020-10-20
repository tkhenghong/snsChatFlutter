import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class UserAPIService {
  String REST_URL = globals.REST_URL;
  String userAPI = "user";

  CustomHttpClient httpClient = Get.find();

  Future<bool> editUser(User user) async {
    return await httpClient.putRequest("$REST_URL/$userAPI", requestBody: user);
  }

  Future<User> getOwnUser() async {
    return User.fromJson(await httpClient.getRequest("$REST_URL/$userAPI/"));
  }
}
