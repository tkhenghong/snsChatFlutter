import 'dart:async';
import 'dart:collection';

import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import '../RestResponseUtils.dart';

class ConversationGroupAPIService {
  String REST_URL = globals.REST_URL;

  Future<Conversation> addConversation(Conversation conversation) async {
    String wholeURL = REST_URL + "/conversationGroup";
    String conversationJsonString = json.encode(conversation.toJson());
    var httpResponse = await http.post(REST_URL + "/conversationGroup", body: conversationJsonString, headers: createHeaders());

    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String conversationGroupId = locationString.replaceAll(wholeURL + "/", "");
      conversation.id = conversationGroupId;
      return conversation;
    }
    return null;
  }

  Future<bool> editConversation(Conversation conversation) async {
    String conversationJsonString = json.encode(conversation.toJson());
    var httpResponse = await http.put(REST_URL + "/conversationGroup", body: conversationJsonString,  headers: createHeaders());

    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteConversation(String conversationGroupId) async {
    var httpResponse = await http.delete(REST_URL + "/conversationGroup" + conversationGroupId);
    return httpResponseIsOK(httpResponse);
  }

  Future<Conversation> getSingleConversation(String conversationGroupId) async {

    var httpResponse = await http.get(REST_URL + "/conversationGroup/" + conversationGroupId);

    if (httpResponseIsOK(httpResponse)) {
      Conversation conversation = new Conversation.fromJson(json.decode(httpResponse.body));
      return conversation;
    }
    return null;
  }

  Future<List<Conversation>> getConversationsForUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/conversationGroup/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      List<Conversation> conversationList = convert.jsonDecode(httpResponse.body) as List<Conversation>;
      return conversationList;
    }
    return null;
  }

  Map<String, String> createHeaders() {
    Map<String, String> headers = new HashMap();
    headers['Content-Type'] = "application/json";
    return headers;
  }
}
