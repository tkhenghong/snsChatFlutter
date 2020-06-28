import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
as globals;
import 'package:snschat_flutter/objects/models/index.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class UserContactAPIService {
  String REST_URL = globals.REST_URL;
  String userContactAPI = "userContact";

  Future<UserContact> addUserContact(UserContact userContact) async {
    String wholeURL = "$REST_URL/$userContactAPI";
    String userContactJsonString = json.encode(userContact.toJson());
    var httpResponse = await http.post(wholeURL, body: userContactJsonString, headers: createAcceptJSONHeader());
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
    return httpResponseIsOK(await http.put("$REST_URL/$userContactAPI", body: userContactJsonString, headers: createAcceptJSONHeader()));
  }

  Future<bool> deleteUserContact(String userContactId) async {
    return httpResponseIsOK(await http.delete("$REST_URL/$userContactAPI/$userContactId"));
  }

  Future<UserContact> getUserContact(String userContactId) async {
    return getUserContactBody(await http.get("$REST_URL/$userContactAPI/$userContactId"));
  }

  Future<UserContact> getUserContactByMobileNo(String mobileNo) async {
    return getUserContactBody(await http.get("$REST_URL/$userContactAPI/mobileNo/$mobileNo"));
  }

  Future<List<UserContact>> getUserContactsByUserId(String userId) async {
    return getUserContactListBody(await http.get("$REST_URL/$userContactAPI/user/$userId"));
  }

  UserContact getUserContactBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      UserContact userContact = new UserContact.fromJson(json.decode(httpResponse.body));
      return userContact;
    }
    return null;
  }

  List<UserContact> getUserContactListBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      Iterable list = json.decode(httpResponse.body);
      List<UserContact> userContactList = list.map((model) => UserContact.fromJson(model)).toList();
      return userContactList;
    }
    return null;
  }
}
