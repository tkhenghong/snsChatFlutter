import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class UnreadMessageAPIService {
  EnvironmentGlobalVariables env = Get.find();
  String unreadMessageAPI = "unreadMessage";

  CustomHttpClient httpClient = Get.find();

  Future<UnreadMessage> getSingleUnreadMessage(String messageId) async {
    return UnreadMessage.fromJson(await httpClient.getRequest("${env.REST_URL}/$unreadMessageAPI/$messageId"));
  }

  Future<UnreadMessage> geUnreadMessageByConversationGroupId(String conversationGroupId) async {
    return UnreadMessage.fromJson(await httpClient.getRequest("${env.REST_URL}/$unreadMessageAPI/conversationGroup/$conversationGroupId"));
  }
}
