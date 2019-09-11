import 'dart:async';

import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/userContact/userContact.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class UserContactAPIService {
  String REST_URL = globals.REST_URL;

  Future<UserContact> addUserContact(UserContact userContact) async {
    String wholeURL = REST_URL + "/userContact";
    String userContactJsonString = json.encode(userContact.toJson());
    var httpResponse = await http.post(REST_URL + "/userContact", body: userContactJsonString, headers: createAcceptJSONHeader());
    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String userContactId = locationString.replaceAll(wholeURL + "/", "");
      userContact.id = userContactId;
      return userContact;
    }
    return null;
  }

  Future<bool> editUserContact(UserContact userContact) async {
    String userContactJsonString = json.encode(userContact.toJson());
    var httpResponse = await http.put(REST_URL + "/userContact", body: userContactJsonString, headers: createAcceptJSONHeader());
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteUserContact(String userContactId) async {
    var httpResponse = await http.delete(REST_URL + "/userContact/" + userContactId);
    return httpResponseIsOK(httpResponse);
  }

  Future<UserContact> getUserContact(String userContactId) async {
    var httpResponse = await http.get(REST_URL + "/userContact/" + userContactId);

    print("getUserContact Success");
    if (httpResponseIsOK(httpResponse)) {
      print("if (httpResponseIsOK(httpResponse))");
      print("httpResponse.body: " + httpResponse.body);
      UserContact userContact = new UserContact.fromJson(json.decode(httpResponse.body));
      return userContact;
    }
    return null;
  }

  Future<UserContact> getUserContactByMobileNo(String mobileNo) async {
    var httpResponse = await http.get(REST_URL + "/userContact/mobileNo/" + mobileNo);

    if (httpResponseIsOK(httpResponse)) {
      UserContact userContact = new UserContact.fromJson(json.decode(httpResponse.body));
      return userContact;
    }
    return null;
  }

  Future<List<UserContact>> getUserContactsByUserId(String userId) async {
    var httpResponse = await http.get(REST_URL + "/userContact/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      Iterable list = json.decode(httpResponse.body);
      List<UserContact> userContactList = list.map((model) => UserContact.fromJson(model)).toList();
      return userContactList;
    }
    return null;
  }
}
