import 'dart:async';

import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';

import '../RestResponseUtils.dart';

class UnreadMessageAPIService {
  String REST_URL = globals.REST_URL;

  Future<String> addUnreadMessage(UnreadMessage unreadMessage) async {
    var httpResponse =
        await http.post(REST_URL + "/unreadMessage", body: unreadMessage);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      var newUnreadMessageId = jsonResponse['id'];
      print("newUnreadMessageId: " + newUnreadMessageId);
      unreadMessage.id = newUnreadMessageId;
      return unreadMessage.id;
    }
    Fluttertoast.showToast(
        msg: 'Unable to create a new unreadMessage.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }

  Future<bool> editUnreadMessage(UnreadMessage unreadMessage) async {
    var httpResponse =
        await http.put(REST_URL + "/unreadMessage", body: unreadMessage);
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteUnreadMessage(UnreadMessage unreadMessage) async {
    var httpResponse =
        await http.delete(REST_URL + "/unreadMessage" + unreadMessage.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<List<UnreadMessage>> getUnreadMessagesOfAUser(String userId) async {
    var httpResponse =
        await http.get(REST_URL + "/unreadMessage/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      List<UnreadMessage> unreadMessageList = convert.jsonDecode(jsonResponse);
      print("unreadMessageList.length: " + unreadMessageList.length.toString());

      return unreadMessageList;
    }
    Fluttertoast.showToast(
        msg: 'Unable to get unreadMessageList for this user.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }
}
