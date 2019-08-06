import 'dart:async';

import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart'
as globals;
import 'package:snschat_flutter/objects/message/message.dart';

import '../RestResponseUtils.dart';
class MessageAPIService {
  String REST_URL = globals.REST_URL;

  Future<String> addMessage(Message message) async {
    var httpResponse =
    await http.post(REST_URL + "/message", body: message);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      var newMessageId = jsonResponse['id'];
      print("newMessageId: " + newMessageId);
      newMessageId.id = newMessageId;
      return newMessageId.id;
    }
    Fluttertoast.showToast(
        msg: 'Unable to create a new message.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }

  Future<bool> editMessage(Message message) async {
    var httpResponse =
    await http.put(REST_URL + "/message", body: message);
    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      var newMessageId = jsonResponse['id'];
      print("newMessageId: " + newMessageId);
      newMessageId.id = newMessageId;
      return true;
    }

    return false;
  }

  Future<bool> deleteMessage(Message message) async {
    var httpResponse =
    await http.delete(REST_URL + "/message" + message.id);
    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      var newMessageId = jsonResponse['id'];
      print("newMessageId: " + newMessageId);
      message.id = newMessageId;
      return true;
    }

    return false;
  }

  Future<List<Message>> getMessagesOfAConversation(String conversationId) async {
    var httpResponse =
    await http.get(REST_URL + "/message/conversation/" + conversationId);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      List<Message> messageList = convert.jsonDecode(jsonResponse);
      print("messageList.length: " + messageList.length.toString());

      return messageList;
    }
    Fluttertoast.showToast(
        msg: 'Unable to get messages for this user.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;

  }
}
