import 'dart:async';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/objects/user/user.dart';

import '../RestResponseUtils.dart';

class UserAPIService {
  String REST_URL = globals.REST_URL;

  Future<User> addUser(User user) async {
    var httpResponse = await http.post(REST_URL + "/user", body: user);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      var newUserId = jsonResponse['id'];
      print("newUserId: " + newUserId);
      user.id = newUserId;
      return user;
    }
    return null;
  }

  Future<bool> editUser(User user) async {
    var httpResponse = await http.put(REST_URL + "/user", body: user);
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteUser(User user) async {
    var httpResponse = await http.delete(REST_URL + "/user" + user.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<User> getUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      User user = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      print("user.id: " + user.id);
      return user;
    }
    return null;
  }
}
