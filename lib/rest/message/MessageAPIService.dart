import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
as globals;
import 'package:snschat_flutter/objects/models/index.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class MessageAPIService {
  String REST_URL = globals.REST_URL;
  String messageAPI = "message";

  Future<ChatMessage> addMessage(ChatMessage message) async {
    String wholeURL = "$REST_URL/$messageAPI";
    String messageJsonString = json.encode(message.toJson());
    var httpResponse = await http.post(wholeURL, body: messageJsonString, headers: createAcceptJSONHeader());
    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String messageId = locationString.replaceAll(wholeURL + "/", "");
      message.id = messageId;
      return message;
    }
    return null;
  }

  Future<bool> editMessage(ChatMessage message) async {
    String messageJsonString = json.encode(message.toJson());
    return httpResponseIsOK(await http.put("$REST_URL/$messageAPI", body: messageJsonString, headers: createAcceptJSONHeader()));
  }

  Future<bool> deleteMessage(String messageId) async {
    var httpResponse = await http.delete("$REST_URL/$messageAPI/$messageId");
    return httpResponseIsOK(httpResponse);
  }

  Future<ChatMessage> getSingleMessage(String messageId) async {
    return getMessageBody(await http.get("$REST_URL/$messageAPI/$messageId"));
  }

  Future<List<ChatMessage>> getMessagesOfAConversation(String conversationId) async {
    return getMessageListBody(await http.get("$REST_URL/$messageAPI/conversation/$conversationId"));
  }

  ChatMessage getMessageBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      ChatMessage message = new ChatMessage.fromJson(json.decode(httpResponse.body));
      return message;
    }
    return null;
  }

  List<ChatMessage> getMessageListBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      List<ChatMessage> messageList = convert.jsonDecode(jsonResponse);
      return messageList;
    }
    return null;
  }
}
