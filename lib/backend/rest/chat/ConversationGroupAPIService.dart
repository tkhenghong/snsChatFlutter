import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/conversationGroup/conversation_group.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class ConversationGroupAPIService {
  String REST_URL = globals.REST_URL;

  Future<ConversationGroup> addConversationGroup(ConversationGroup conversation) async {
    String wholeURL = REST_URL + "/conversationGroup";
    String conversationJsonString = json.encode(conversation.toJson());
    var httpResponse = await http.post(REST_URL + "/conversationGroup", body: conversationJsonString, headers: createAcceptJSONHeader());

    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String conversationGroupId = locationString.replaceAll(wholeURL + "/", "");
      conversation.id = conversationGroupId;
      return conversation;
    }
    return null;
  }

  Future<bool> editConversationGroup(ConversationGroup conversation) async {
    String conversationJsonString = json.encode(conversation.toJson());
    var httpResponse = await http.put(REST_URL + "/conversationGroup", body: conversationJsonString, headers: createAcceptJSONHeader());
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteConversationGroup(String conversationGroupId) async {
    var httpResponse = await http.delete(REST_URL + "/conversationGroup/" + conversationGroupId);
    return httpResponseIsOK(httpResponse);
  }

  Future<ConversationGroup> getSingleConversationGroup(String conversationGroupId) async {
    var httpResponse = await http.get(REST_URL + "/conversationGroup/" + conversationGroupId);
    if (httpResponseIsOK(httpResponse)) {
      ConversationGroup conversation = new ConversationGroup.fromJson(json.decode(httpResponse.body));
      return conversation;
    }
    return null;
  }

  Future<List<ConversationGroup>> getConversationGroupsForUserByMobileNo(String mobileNo) async {
    var httpResponse = await http.get(REST_URL + "/conversationGroup/user/mobileNo/" + mobileNo);
    if (httpResponseIsOK(httpResponse)) {
      Iterable list = json.decode(httpResponse.body);
      List<ConversationGroup> conversationList = list.map((model) => ConversationGroup.fromJson(model)).toList();
      return conversationList;
    } else {
      print("if (!httpResponseIsOK(httpResponse))");
    }
    return null;
  }
}
