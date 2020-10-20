import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';
import 'package:snschat_flutter/rest/dio/http_file/http_file.service.dart';

class ChatMessageAPIService {
  String REST_URL = globals.REST_URL;
  String messageAPI = "chatMessage";

  CustomHttpClient httpClient = Get.find();
  HTTPFileService httpFileService = Get.find();

  Future<ChatMessage> addChatMessage(CreateChatMessageRequest chatMessageRequest) async {
    return ChatMessage.fromJson(await httpClient.postRequest("$REST_URL/$messageAPI", requestBody: chatMessageRequest));
  }

  Future<MultimediaResponse> uploadChatMessageMultimedia(String chatMessageId, File file, {Function uploadProgress}) async {
    Response<dynamic> response = await httpFileService.uploadFile("$REST_URL/$messageAPI/$chatMessageId/multimedia", [file], onSendProgress: uploadProgress);
    return MultimediaResponse.fromJson(response.data);
  }

  Future<dynamic> getChatMessageMultimedia(String multimediaId, String savePath, Function(int, int) downloadProgress) async {
    Response<dynamic> response = await httpFileService.downloadFile("$REST_URL/$messageAPI/multimedia", savePath, onDownloadProgress: downloadProgress);
    return response.data; // Return file data to allow BLOC architecture to handle the saving path of the file.
  }

  Future<bool> deleteChatMessage(String chatMessageId) async {
    return await httpClient.deleteRequest("$REST_URL/$messageAPI/$chatMessageId");
  }

  Future<ChatMessage> getSingleChatMessage(String messageId) async {
    return ChatMessage.fromJson(await httpClient.getRequest("$REST_URL/$messageAPI/$messageId"));
  }

  Future<List<ChatMessage>> getChatMessagesOfAConversation(String conversationId, Pageable pageRequest) async {
    List<dynamic> chatMessageListRaw = await httpClient.postRequest("$REST_URL/$messageAPI/conversation/$conversationId", requestBody: pageRequest);
    return chatMessageListRaw.map((e) => ChatMessage.fromJson(e)).toList();
  }
}
