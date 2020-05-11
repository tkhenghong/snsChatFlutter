import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class ConversationGroupAPIService {
  String REST_URL = globals.REST_URL;
  String conversationGroupAPI = "conversationGroup";

  Future<ConversationGroup> addConversationGroup(
      ConversationGroup conversation) async {
    String wholeURL = "$REST_URL/$conversationGroupAPI";
    String conversationJsonString = json.encode(conversation.toJson());
    var httpResponse = await http.post(wholeURL,
        body: conversationJsonString, headers: createAcceptJSONHeader());

    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String conversationGroupId =
          locationString.replaceAll(wholeURL + "/", "");
      conversation.id = conversationGroupId;
      return conversation;
    }
    return null;
  }

  Future<bool> editConversationGroup(ConversationGroup conversation) async {
    String conversationJsonString = json.encode(conversation.toJson());
    return httpResponseIsOK(await http.put("$REST_URL/$conversationGroupAPI",
        body: conversationJsonString, headers: createAcceptJSONHeader()));
  }

  Future<bool> deleteConversationGroup(String conversationGroupId) async {
    return httpResponseIsOK(await http
        .delete("$REST_URL/$conversationGroupAPI/$conversationGroupId"));
  }

  Future<ConversationGroup> getSingleConversationGroup(
      String conversationGroupId) async {
    return getConversationGroupBody(
        await http.get("$REST_URL/$conversationGroupAPI/$conversationGroupId"));
  }

  Future<List<ConversationGroup>> getConversationGroupsForUserByMobileNo(
      String mobileNo) async {
    return getConversationGroupListBody(await http
        .get("$REST_URL/$conversationGroupAPI/user/mobileNo/$mobileNo"));
  }

  ConversationGroup getConversationGroupBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      ConversationGroup conversation =
          new ConversationGroup.fromJson(json.decode(httpResponse.body));
      return conversation;
    }
    return null;
  }

  List<ConversationGroup> getConversationGroupListBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      Iterable list = json.decode(httpResponse.body);
      List<ConversationGroup> conversationList =
          list.map((model) => ConversationGroup.fromJson(model)).toList();
      return conversationList;
    }
    return null;
  }
}
