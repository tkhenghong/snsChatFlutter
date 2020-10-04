import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/customhttpClient/CustomHttpClient.dart';

class UnreadMessageAPIService {
  String REST_URL = globals.REST_URL;
  String unreadMessageAPI = "unreadMessage";

  CustomHttpClient httpClient = new CustomHttpClient();

//  Future<UnreadMessage> addUnreadMessage(UnreadMessage unreadMessage) async {
//    return UnreadMessage.fromJson(await httpClient.postRequest("$REST_URL/$unreadMessageAPI", requestBody: unreadMessage));
//  }

  Future<bool> editUnreadMessage(UnreadMessage unreadMessage) async {
    return await httpClient.putRequest("$REST_URL/$unreadMessageAPI", requestBody: unreadMessage);
  }

//  Future<bool> deleteUnreadMessage(String unreadMessageId) async {
//    return await httpClient.deleteRequest("$REST_URL/$unreadMessageAPI/$unreadMessageId");
//  }

  Future<UnreadMessage> getSingleUnreadMessage(String messageId) async {
    return UnreadMessage.fromJson(await httpClient.getRequest("$REST_URL/$unreadMessageAPI/$messageId"));
  }

  Future<UnreadMessage> geUnreadMessageByConversationGroupId(String conversationGroupId) async {
    return UnreadMessage.fromJson(await httpClient.getRequest("$REST_URL/$unreadMessageAPI/conversationGroup/$conversationGroupId"));
  }

  Future<List<UnreadMessage>> getUnreadMessagesOfAUser() async {
    List<dynamic> unreadMessageListRaw = await httpClient.getRequest("$REST_URL/$unreadMessageAPI/user");
    return unreadMessageListRaw.map((e) => UnreadMessage.fromJson(e)).toList();
  }
}
