import 'dart:async';

import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/objects/chat/conversation_group.dart';

import '../RestResponseUtils.dart';

class ConversationGroupAPIService {
  String REST_URL = globals.REST_URL;

  Future<String> addConversation(Conversation conversation) async {
    var httpResponse =
        await http.post(REST_URL + "/conversationGroup", body: conversation);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      var newConversationId = jsonResponse['id'];
      print("newConversationId: " + newConversationId);
      conversation.id = newConversationId;
      return conversation.id;
    }
    Fluttertoast.showToast(
        msg: 'Unable to create a new conversation.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }

  Future<bool> editConversation(Conversation conversation) async {
    var httpResponse =
        await http.put(REST_URL + "/conversationGroup", body: conversation);

    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteConversation(Conversation conversation) async {
    var httpResponse =
        await http.delete(REST_URL + "/conversationGroup" + conversation.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<Conversation> getSingleConversation(String conversationGroupId) async {
    var httpResponse =
        await http.get(REST_URL + "/conversationGroup/" + conversationGroupId);

    if (httpResponseIsOK(httpResponse)) {
      Conversation conversation =
          convert.jsonDecode(httpResponse.body) as Conversation;
      print("conversation.id: " + conversation.id);
      return conversation;
    }

    Fluttertoast.showToast(
        msg: 'Unable to get the conversation.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }

  Future<List<Conversation>> getConversationsForUser(String userId) async {
    var httpResponse =
        await http.get(REST_URL + "/conversationGroup/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      List<Conversation> conversationList =
          convert.jsonDecode(httpResponse.body) as List<Conversation>;
      print("conversationList.length: " + conversationList.length.toString());
      return conversationList;
    }

    Fluttertoast.showToast(
        msg: 'Unable to get the conversations for the user.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }
}
