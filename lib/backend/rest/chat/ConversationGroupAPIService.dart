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
    print("ConversationGroupAPIService.addConversation()");

    String wholeURL = REST_URL + "/conversationGroup";
    Map<String, String> headers = new HashMap();
    headers['Content-Type'] = "application/json";
    String conversationJsonString = json.encode(conversation.toJson());
    print("conversationJsonString: " + conversationJsonString);
    print("wholeURL: " + wholeURL);
    var httpResponse = await http.post(REST_URL + "/conversationGroup", body: conversationJsonString, headers: headers);

    if (httpResponseIsOK(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      print("locationString: " + locationString);
      print("httpResponse: " + httpResponse.toString());
      String conversationGroupId = locationString.replaceAll(wholeURL + "/", "");
      print("conversationGroupId: " + conversationGroupId);
      conversation.id = conversationGroupId;
      return conversation;
    }
    return null;
  }

  Future<bool> editConversation(Conversation conversation) async {
    var httpResponse = await http.put(REST_URL + "/conversationGroup", body: conversation);

    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteConversation(Conversation conversation) async {
    var httpResponse = await http.delete(REST_URL + "/conversationGroup" + conversation.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<Conversation> getSingleConversation(String conversationGroupId) async {
    var httpResponse = await http.get(REST_URL + "/conversationGroup/" + conversationGroupId);

    if (httpResponseIsOK(httpResponse)) {
      Conversation conversation = convert.jsonDecode(httpResponse.body) as Conversation;
      print("conversation.id: " + conversation.id);
      return conversation;
    }
    return null;
  }

  Future<List<Conversation>> getConversationsForUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/conversationGroup/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      List<Conversation> conversationList = convert.jsonDecode(httpResponse.body) as List<Conversation>;
      print("conversationList.length: " + conversationList.length.toString());
      return conversationList;
    }
    return null;
  }
}
