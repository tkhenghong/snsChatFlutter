import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class ChatMessageAPIService {
  String REST_URL = globals.REST_URL;
  String messageAPI = "chatMessage";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<ChatMessage> addChatMessage(ChatMessage message) async {
    return ChatMessage.fromJson(await httpClient.postRequest("$REST_URL/$messageAPI", requestBody: message));
  }

  Future<bool> editChatMessage(ChatMessage message) async {
    return await httpClient.putRequest("$REST_URL/$messageAPI", requestBody: message);
  }

  Future<bool> deleteChatMessage(String messageId) async {
    return await httpClient.deleteRequest("$REST_URL/$messageAPI/$messageId");
  }

  Future<ChatMessage> getSingleChatMessage(String messageId) async {
    return ChatMessage.fromJson(await httpClient.getRequest("$REST_URL/$messageAPI/$messageId"));
  }

  Future<List<ChatMessage>> getChatMessagesOfAConversation(String conversationId) async {
    List<dynamic> chatMessageListRaw =  await httpClient.getRequest("$REST_URL/$messageAPI/conversation/$conversationId");
    return chatMessageListRaw.map((e) => ChatMessage.fromJson(e)).toList();
  }
}
