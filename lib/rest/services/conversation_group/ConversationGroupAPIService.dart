import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class ConversationGroupAPIService {
  String REST_URL = globals.REST_URL;
  String conversationGroupAPI = "conversationGroup";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<ConversationGroup> addConversationGroup(CreateConversationGroupRequest createConversationGroupRequest) async {
    return ConversationGroup.fromJson(await httpClient.postRequest("$REST_URL/$conversationGroupAPI", requestBody: createConversationGroupRequest));
  }

  Future<bool> editConversationGroup(ConversationGroup conversation) async {
    return await httpClient.putRequest("$REST_URL/$conversationGroupAPI", requestBody: conversation);
  }

  Future<bool> deleteConversationGroup(String conversationGroupId) async {
    return await httpClient.deleteRequest("$REST_URL/$conversationGroupAPI/$conversationGroupId");
  }

  Future<ConversationGroup> getSingleConversationGroup(String conversationGroupId) async {
    return ConversationGroup.fromJson(await httpClient.getRequest("$REST_URL/$conversationGroupAPI/$conversationGroupId"));
  }

  Future<List<ConversationGroup>> getUserOwnConversationGroups() async {
    List<dynamic> conversationGroupListRaw = await httpClient.getRequest("$REST_URL/$conversationGroupAPI/user");
    return conversationGroupListRaw.map((e) => ConversationGroup.fromJson(e)).toList();
  }
}
