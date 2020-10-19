import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';
import 'package:snschat_flutter/rest/dio/http_file/http_file.service.dart';

class ConversationGroupAPIService {
  String REST_URL = globals.REST_URL;
  String conversationGroupAPI = "conversationGroup";

  CustomHttpClient httpClient = Get.find();
  HTTPFileService httpFileService = Get.find();

  Future<ConversationGroup> addConversationGroup(CreateConversationGroupRequest createConversationGroupRequest) async {
    return ConversationGroup.fromJson(await httpClient.postRequest("$REST_URL/$conversationGroupAPI", requestBody: createConversationGroupRequest));
  }

  Future<MultimediaResponse> uploadConversationGroupGroupPhoto(String conversationGroupId, File file, Function uploadProgress) async {
    Response<dynamic> response = await httpFileService.uploadFile("$REST_URL/$conversationGroupAPI", [file], onSendProgress: uploadProgress);
    return MultimediaResponse.fromJson(response.data);
  }

  Future<dynamic> getConversationGroupGroupPhoto(String multimediaId, String savePath, Function(int, int) downloadProgress) async {
    Response<dynamic> response = await httpFileService.downloadFile("$REST_URL/$conversationGroupAPI/multimedia", savePath, onDownloadProgress: downloadProgress);
    return response.data; // Return file data to allow BLOC architecture to handle the saving path of the file.
  }

  Future<bool> deleteConversationGroupProfilePhoto(String conversationGroupId) async {
    return await httpClient.deleteRequest("$REST_URL/$conversationGroupAPI/$conversationGroupId/groupPhoto");
  }

  Future<ConversationGroup> editConversationGroup(EditConversationGroupRequest editConversationGroupRequest) async {
    return ConversationGroup.fromJson(await httpClient.putRequest("$REST_URL/$conversationGroupAPI", requestBody: editConversationGroupRequest));
  }

  Future<bool> deleteConversationGroup(String conversationGroupId) async {
    return await httpClient.deleteRequest("$REST_URL/$conversationGroupAPI/$conversationGroupId");
  }

  Future<ConversationGroup> getSingleConversationGroup(String conversationGroupId) async {
    return ConversationGroup.fromJson(await httpClient.getRequest("$REST_URL/$conversationGroupAPI/$conversationGroupId"));
  }

  Future<ConversationPageableResponse> getUserOwnConversationGroups(GetConversationGroupsRequest getConversationGroupsRequest) async {
    return ConversationPageableResponse.fromJson(await httpClient.postRequest("$REST_URL/$conversationGroupAPI/user", requestBody: getConversationGroupsRequest));
  }
}
