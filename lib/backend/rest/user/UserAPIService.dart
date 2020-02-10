import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/user/user.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class UserAPIService {
  String REST_URL = globals.REST_URL;

  Future<User> addUser(User user) async {
    String wholeURL = REST_URL + "/user";
    String userJsonString = json.encode(user.toJson());
    var httpResponse = await http.post(REST_URL + "/user", body: userJsonString, headers: createAcceptJSONHeader());
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
    var httpResponse = await http.put(REST_URL + "/user", body: userJsonString, headers: createAcceptJSONHeader());
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteUser(String userId) async {
    var httpResponse = await http.delete(REST_URL + "/user/" + userId);
    return httpResponseIsOK(httpResponse);
  }

  Future<User> getUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      User user = new User.fromJson(json.decode(httpResponse.body));
      return user;
    }
    return null;
  }

  Future<User> getUserByUsingGoogleAccountId(String googleAccountId) async {
    var httpResponse = await http.get(REST_URL + "/user/googleAccountId/" + googleAccountId);

    if (httpResponseIsOK(httpResponse)) {
      User user = new User.fromJson(json.decode(httpResponse.body));
      return user;
    }
    return null;
  }

  Future<User> getUserByUsingMobileNo(String mobileNo) async {
    var httpResponse = await http.get(REST_URL + "/user/mobileNo/" + mobileNo);

    if (httpResponseIsOK(httpResponse)) {
      User user = new User.fromJson(json.decode(httpResponse.body));
      return user;
    }
    return null;
  }
}
