import 'dart:async';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/userContact/userContact.dart';

import '../RestResponseUtils.dart';

class UserContactAPIService {
  String REST_URL = globals.REST_URL;

  Future<UserContact> addUserContact(UserContact userContact) async {
    var httpResponse = await http.post(REST_URL + "/userContact", body: userContact);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      var newUserContactId = jsonResponse['id'];
      print("newUserContactId: " + newUserContactId);
      userContact.id = newUserContactId;
      return userContact;
    }
    return null;
  }

  Future<bool> editUserContact(UserContact userContact) async {
    var httpResponse = await http.put(REST_URL + "/userContact", body: userContact);
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteUserContact(UserContact userContact) async {
    var httpResponse = await http.delete(REST_URL + "/userContact" + userContact.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<UserContact> getUserContact(String userContactId) async {
    var httpResponse = await http.get(REST_URL + "/userContact/" + userContactId);

    if (httpResponseIsOK(httpResponse)) {
      UserContact userContact = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      print("userContact.id: " + userContact.id);
      return userContact;
    }
    return null;
  }
}