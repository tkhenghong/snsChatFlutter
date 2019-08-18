import 'dart:async';

import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/message/message.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class MessageAPIService {
  String REST_URL = globals.REST_URL;

  Future<Message> addMessage(Message message) async {
    String wholeURL = REST_URL + "/message";
    String messageJsonString = json.encode(message.toJson());
    var httpResponse = await http.post(REST_URL + "/message", body: messageJsonString, headers: createAcceptJSONHeader());
    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String messageId = locationString.replaceAll(wholeURL + "/", "");
      message.id = messageId;
      return message;
    }
    return null;
  }

  Future<bool> editMessage(Message message) async {
    String messageJsonString = json.encode(message.toJson());
    var httpResponse = await http.put(REST_URL + "/message", body: messageJsonString, headers: createAcceptJSONHeader());
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteMessage(String messageId) async {
    var httpResponse = await http.delete(REST_URL + "/message/" + messageId);
    return httpResponseIsOK(httpResponse);
  }

  Future<Message> getSingleMessage(String messageId) async {
    var httpResponse = await http.get(REST_URL + "/message/" + messageId);
    if (httpResponseIsOK(httpResponse)) {
      Message message = new Message.fromJson(json.decode(httpResponse.body));
      return message;
    }
    return null;
  }

  Future<List<Message>> getMessagesOfAConversation(String conversationId) async {
    var httpResponse = await http.get(REST_URL + "/message/conversation/" + conversationId);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      List<Message> messageList = convert.jsonDecode(jsonResponse);
      print("messageList.length: " + messageList.length.toString());

      return messageList;
    }
    return null;
  }
}
