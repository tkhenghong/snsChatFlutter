import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as HTTPDio;
import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/models/user_contact/user_contact.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';
import 'package:snschat_flutter/rest/index.dart';

class UserContactAPIService {
  EnvironmentGlobalVariables env = Get.find();
  String userContactAPI = "userContact";

  CustomHttpClient httpClient = Get.find();
  HTTPFileService httpFileService = Get.find();

  Future<UserContact> editOwnUserContact(UserContact userContact) async {
    return UserContact.fromJson(await httpClient.putRequest("${env.REST_URL}/$userContactAPI", requestBody: userContact));
  }

  Future<MultimediaResponse> uploadOwnUserContactProfilePhoto(String userContactId, File file, {Function uploadProgress}) async {
    HTTPDio.Response<dynamic> response = await httpFileService.uploadFile("${env.REST_URL}/$userContactAPI/$userContactId/profilePhoto", [file], onSendProgress: uploadProgress);
    return MultimediaResponse.fromJson(response.data);
  }

  Future<dynamic> getOwnUserContactProfilePhoto(String savePath, Function(int, int) downloadProgress) async {
    HTTPDio.Response<dynamic> response = await httpFileService.downloadFile("${env.REST_URL}/$userContactAPI/profilePhoto", savePath, onDownloadProgress: downloadProgress);
    return response.data; // Return file data to allow BLOC architecture to handle the saving path of the file.
  }

  Future<dynamic> getUserContactProfilePhoto(String userContactId, String savePath, Function(int, int) downloadProgress) async {
    HTTPDio.Response<dynamic> response = await httpFileService.downloadFile("${env.REST_URL}/$userContactAPI/$userContactId/profilePhoto", savePath, onDownloadProgress: downloadProgress);
    return response.data; // Return file data to allow BLOC architecture to handle the saving path of the file.
  }

  Future<bool> deleteOwnUserContactProfilePhoto(String userContactId) async {
    return await httpClient.deleteRequest("${env.REST_URL}/$userContactAPI/$userContactId/profilePhoto");
  }

  Future<UserContact> getUserContact(String userContactId) async {
    return UserContact.fromJson(await httpClient.getRequest("${env.REST_URL}/$userContactAPI/$userContactId"));
  }

  Future<UserContact> getUserContactByMobileNo(String mobileNo) async {
    return UserContact.fromJson(await httpClient.getRequest("${env.REST_URL}/$userContactAPI/mobileNo/$mobileNo"));
  }

  Future<List<UserContact>> getUserContactsByConversationGroup(String conversationGroupId) async {
    List<dynamic> userContactsRaw = await httpClient.getRequest("${env.REST_URL}/$userContactAPI/conversationGroup/$conversationGroupId");
    return userContactsRaw.map((e) => UserContact.fromJson(e)).toList();
  }

  Future<UserContact> getOwnUserContact() async {
    return UserContact.fromJson(await httpClient.getRequest("${env.REST_URL}/$userContactAPI"));
  }

  /// Get all UserContacts of the signed in user, including yourself with pangination.
  /// Object is Page<UserContact>
  Future<PageInfo> getUserContactsOfAUser(GetUserOwnUserContactsRequest getUserOwnUserContactsRequest) async {
    return PageInfo.fromJson(await httpClient.postRequest("${env.REST_URL}/$userContactAPI/user", requestBody: getUserOwnUserContactsRequest));
  }
}
