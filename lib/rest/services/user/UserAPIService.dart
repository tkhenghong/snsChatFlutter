import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class UserAPIService {
  EnvironmentGlobalVariables env = Get.find();
  String userAPI = "user";

  CustomHttpClient httpClient = Get.find();

  Future<bool> editUser(User user) async {
    return await httpClient.putRequest("${env.REST_URL}/$userAPI", requestBody: user);
  }

  Future<User> getOwnUser() async {
    return User.fromJson(await httpClient.getRequest("${env.REST_URL}/$userAPI/"));
  }
}
