import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/customhttpClient/CustomHttpClient.dart';

class MessageAPIService {
  String REST_URL = globals.REST_URL;
  String messageAPI = "message";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<ChatMessage> addMessage(ChatMessage message) async {
    return ChatMessage.fromJson(await httpClient.postRequest("$REST_URL/$messageAPI", requestBody: message));
  }

  Future<bool> editMessage(ChatMessage message) async {
    return await httpClient.putRequest("$REST_URL/$messageAPI", requestBody: message);
  }

  Future<bool> deleteMessage(String messageId) async {
    return await httpClient.deleteRequest("$REST_URL/$messageAPI/$messageId");
  }

  Future<ChatMessage> getSingleMessage(String messageId) async {
    return ChatMessage.fromJson(await httpClient.getRequest("$REST_URL/$messageAPI/$messageId"));
  }

  Future<List<ChatMessage>> getMessagesOfAConversation(String conversationId) async {
    List<dynamic> chatMesageListRaw =  await httpClient.getRequest("$REST_URL/$messageAPI/conversation/$conversationId");
    return chatMesageListRaw.map((e) => ChatMessage.fromJson(e)).toList();
  }
}
