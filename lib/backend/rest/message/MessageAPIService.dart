import 'dart:async';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/objects/message/message.dart';

import '../RestResponseUtils.dart';

class MessageAPIService {
  String REST_URL = globals.REST_URL;

  Future<Message> addMessage(Message message) async {
    var httpResponse = await http.post(REST_URL + "/message", body: message);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      var newMessageId = jsonResponse['id'];
      print("newMessageId: " + newMessageId);
      newMessageId.id = newMessageId;
      return newMessageId;
    }
    return null;
  }

  Future<bool> editMessage(Message message) async {
    var httpResponse = await http.put(REST_URL + "/message", body: message);
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteMessage(Message message) async {
    var httpResponse = await http.delete(REST_URL + "/message" + message.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<List<Message>> getMessagesOfAConversation(
      String conversationId) async {
    var httpResponse =
        await http.get(REST_URL + "/message/conversation/" + conversationId);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      List<Message> messageList = convert.jsonDecode(jsonResponse);
      print("messageList.length: " + messageList.length.toString());

      return messageList;
    }
    return null;
  }
}
