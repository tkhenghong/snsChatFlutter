import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as HTTPDio;
import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';
import 'package:snschat_flutter/rest/dio/http_file/http_file.service.dart';

class ChatMessageAPIService {
  EnvironmentGlobalVariables env = Get.find();
  String messageAPI = "chatMessage";

  CustomHttpClient httpClient = Get.find();
  HTTPFileService httpFileService = Get.find();

  Future<ChatMessage> addChatMessage(CreateChatMessageRequest chatMessageRequest) async {
    return ChatMessage.fromJson(await httpClient.postRequest("${env.REST_URL}/$messageAPI", requestBody: chatMessageRequest));
  }

  Future<MultimediaResponse> uploadChatMessageMultimedia(String chatMessageId, File file, {Function uploadProgress}) async {
    HTTPDio.Response<dynamic> response = await httpFileService.uploadFile("${env.REST_URL}/$messageAPI/$chatMessageId/multimedia", [file], onSendProgress: uploadProgress);
    return MultimediaResponse.fromJson(response.data);
  }

  Future<dynamic> getChatMessageMultimedia(String multimediaId, String savePath, Function(int, int) downloadProgress) async {
    HTTPDio.Response<dynamic> response = await httpFileService.downloadFile("${env.REST_URL}/$messageAPI/multimedia", savePath, onDownloadProgress: downloadProgress);
    return response.data; // Return file data to allow BLOC architecture to handle the saving path of the file.
  }

  Future<bool> deleteChatMessage(String chatMessageId) async {
    return await httpClient.deleteRequest("${env.REST_URL}/$messageAPI/$chatMessageId");
  }

  Future<ChatMessage> getSingleChatMessage(String messageId) async {
    return ChatMessage.fromJson(await httpClient.getRequest("${env.REST_URL}/$messageAPI/$messageId"));
  }

  /// Returns ChatMessage object in it's contents.
  Future<PageInfo> getChatMessagesOfAConversation(String conversationId, Pageable pageRequest) async {
    return PageInfo.fromJson(await httpClient.postRequest("${env.REST_URL}/$messageAPI/conversation/$conversationId", requestBody: pageRequest));
  }
}
