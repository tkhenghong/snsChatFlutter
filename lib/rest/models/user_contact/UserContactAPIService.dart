import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/customhttpClient/CustomHttpClient.dart';

class UserContactAPIService {
  String REST_URL = globals.REST_URL;
  String userContactAPI = "userContact";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<UserContact> addUserContact(UserContact userContact) async {
    return UserContact.fromJson(await httpClient.postRequest("$REST_URL/$userContactAPI", requestBody: userContact));
  }

  Future<bool> editUserContact(UserContact userContact) async {
    return await httpClient.putRequest("$REST_URL/$userContactAPI", requestBody: userContact);
  }

  Future<bool> deleteUserContact(String userContactId) async {
    return await httpClient.deleteRequest("$REST_URL/$userContactAPI/$userContactId");
  }

  Future<UserContact> getUserContact(String userContactId) async {
    return UserContact.fromJson(await httpClient.getRequest("$REST_URL/$userContactAPI/$userContactId"));
  }

  Future<UserContact> getUserContactByMobileNo(String mobileNo) async {
    return UserContact.fromJson(await httpClient.getRequest("$REST_URL/$userContactAPI/mobileNo/$mobileNo"));
  }

  Future<List<UserContact>> getUserContactsByUserId(String userId) async {
    List<dynamic> userContactListRaw = await httpClient.getRequest("$REST_URL/$userContactAPI/user/$userId");
    return userContactListRaw.map((e) => UserContact.fromJson(e)).toList();
  }
}
