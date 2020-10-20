import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class UnreadMessageAPIService {
  String REST_URL = globals.REST_URL;
  String unreadMessageAPI = "unreadMessage";

  CustomHttpClient httpClient = Get.find();

  Future<UnreadMessage> getSingleUnreadMessage(String messageId) async {
    return UnreadMessage.fromJson(await httpClient.getRequest("$REST_URL/$unreadMessageAPI/$messageId"));
  }

  Future<UnreadMessage> geUnreadMessageByConversationGroupId(String conversationGroupId) async {
    return UnreadMessage.fromJson(await httpClient.getRequest("$REST_URL/$unreadMessageAPI/conversationGroup/$conversationGroupId"));
  }
}
