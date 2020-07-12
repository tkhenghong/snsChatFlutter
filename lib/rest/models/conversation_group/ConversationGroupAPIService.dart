import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/customHttpClient/CustomHttpClient.dart';

class ConversationGroupAPIService {
  String REST_URL = globals.REST_URL;
  String conversationGroupAPI = "conversationGroup";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<ConversationGroup> addConversationGroup(ConversationGroup conversation) async {
    return ConversationGroup.fromJson(await httpClient.postRequest("$REST_URL/$conversationGroupAPI", requestBody: conversation));
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

  Future<List<ConversationGroup>> getConversationGroupsForUserByMobileNo(String mobileNo) async {
    List<dynamic> conversationGroupListRaw = await httpClient.getRequest("$REST_URL/$conversationGroupAPI/user/mobileNo/$mobileNo");
    return conversationGroupListRaw.map((e) => ConversationGroup.fromJson(e)).toList();
  }
}