import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
as globals;
import 'package:snschat_flutter/objects/models/index.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class UserAPIService {
  String REST_URL = globals.REST_URL;
  String userAPI = "user";

  Future<User> addUser(User user) async {
    String wholeURL = "$REST_URL/$userAPI";
    String userJsonString = json.encode(user.toJson());
    var httpResponse = await http.post(wholeURL, body: userJsonString, headers: createAcceptJSONHeader());
    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String userId = locationString.replaceAll(wholeURL + "/", "");
      user.id = userId;
      return user;
    }
    return null;
  }

  Future<bool> editUser(User user) async {
    String userJsonString = json.encode(user.toJson());
    return httpResponseIsOK(await http.put("$REST_URL/$userAPI", body: userJsonString, headers: createAcceptJSONHeader()));
  }

  Future<bool> deleteUser(String userId) async {
    return httpResponseIsOK(await http.delete("$REST_URL/$userAPI/$userId"));
  }

  Future<User> getUser(String userId) async {
    return getUserBody(await http.get("$REST_URL/$userAPI/$userId"));
  }

  Future<User> getUserByUsingGoogleAccountId(String googleAccountId) async {
    return getUserBody(await http.get("$REST_URL/$userAPI/googleAccountId/$googleAccountId"));
  }

  Future<User> getUserByUsingMobileNo(String mobileNo) async {
    return getUserBody(await http.get("$REST_URL/$userAPI/mobileNo/$mobileNo"));
  }

  User getUserBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      User user = new User.fromJson(json.decode(httpResponse.body));
      return user;
    }
    return null;
  }
}
