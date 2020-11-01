import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/models/user_contact/user_contact.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';
import 'package:snschat_flutter/rest/index.dart';

class UserContactAPIService {
  String REST_URL = globals.REST_URL;
  String userContactAPI = "userContact";

  CustomHttpClient httpClient = Get.find();
  HTTPFileService httpFileService = Get.find();

  Future<UserContact> editOwnUserContact(UserContact userContact) async {
    return UserContact.fromJson(await httpClient.putRequest("$REST_URL/$userContactAPI", requestBody: userContact));
  }

  Future<MultimediaResponse> uploadOwnUserContactProfilePhoto(String userContactId, File file, {Function uploadProgress}) async {
    Response<dynamic> response = await httpFileService.uploadFile("$REST_URL/$userContactAPI/$userContactId/profilePhoto", [file], onSendProgress: uploadProgress);
    return MultimediaResponse.fromJson(response.data);
  }

  Future<dynamic> getOwnUserContactProfilePhoto(String savePath, Function(int, int) downloadProgress) async {
    Response<dynamic> response = await httpFileService.downloadFile("$REST_URL/$userContactAPI/profilePhoto", savePath, onDownloadProgress: downloadProgress);
    return response.data; // Return file data to allow BLOC architecture to handle the saving path of the file.
  }

  Future<dynamic> getUserContactProfilePhoto(String userContactId, String savePath, Function(int, int) downloadProgress) async {
    Response<dynamic> response = await httpFileService.downloadFile("$REST_URL/$userContactAPI/$userContactId/profilePhoto", savePath, onDownloadProgress: downloadProgress);
    return response.data; // Return file data to allow BLOC architecture to handle the saving path of the file.
  }

  Future<bool> deleteOwnUserContactProfilePhoto(String userContactId) async {
    return await httpClient.deleteRequest("$REST_URL/$userContactAPI/$userContactId/profilePhoto");
  }

  Future<UserContact> getUserContact(String userContactId) async {
    return UserContact.fromJson(await httpClient.getRequest("$REST_URL/$userContactAPI/$userContactId"));
  }

  Future<UserContact> getUserContactByMobileNo(String mobileNo) async {
    return UserContact.fromJson(await httpClient.getRequest("$REST_URL/$userContactAPI/mobileNo/$mobileNo"));
  }

  Future<UserContact> getOwnUserContact() async {
    return UserContact.fromJson(await httpClient.getRequest("$REST_URL/$userContactAPI"));
  }

  /// Get all UserContacts of the signed in user, including yourself with pangination.
  /// Object is Page<UserContact>
  Future<PageInfo> getUserContactsOfAUser(GetUserOwnUserContactsRequest getUserOwnUserContactsRequest) async {
    return PageInfo.fromJson(await httpClient.postRequest("$REST_URL/$userContactAPI/user", requestBody: getUserOwnUserContactsRequest));
  }
}
