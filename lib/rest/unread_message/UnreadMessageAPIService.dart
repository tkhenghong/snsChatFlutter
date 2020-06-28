import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
as globals;
import 'package:snschat_flutter/objects/models/index.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class UnreadMessageAPIService {
  String REST_URL = globals.REST_URL;
  String unreadMessageAPI = "unreadMessage";

  Future<UnreadMessage> addUnreadMessage(UnreadMessage unreadMessage) async {
    String wholeURL = REST_URL + unreadMessageAPI;
    String unreadMessageJsonString = json.encode(unreadMessage.toJson());
    var httpResponse = await http.post("$REST_URL/$unreadMessageAPI", body: unreadMessageJsonString, headers: createAcceptJSONHeader());
    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String unreadMessageId = locationString.replaceAll(wholeURL + "/", "");
      unreadMessage.id = unreadMessageId;
      return unreadMessage;
    }
    return null;
  }

  Future<bool> editUnreadMessage(UnreadMessage unreadMessage) async {
    String unreadMessageJsonString = json.encode(unreadMessage.toJson());
    return httpResponseIsOK(await http.put("$REST_URL/$unreadMessageAPI", body: unreadMessageJsonString, headers: createAcceptJSONHeader()));
  }

  Future<bool> deleteUnreadMessage(String unreadMessageId) async {
    return httpResponseIsOK(await http.delete("$REST_URL/$unreadMessageAPI/$unreadMessageId"));
  }

  Future<UnreadMessage> getSingleUnreadMessage(String messageId) async {
    return getUnreadMessageBody(await http.get("$REST_URL/$unreadMessageAPI/$messageId"));
  }

  Future<List<UnreadMessage>> getUnreadMessagesOfAUser(String userId) async {
    return getUnreadMessageListBody(await http.get("$REST_URL/$unreadMessageAPI/user/$userId"));
  }

  UnreadMessage getUnreadMessageBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      UnreadMessage message = new UnreadMessage.fromJson(json.decode(httpResponse.body));
      return message;
    }
    return null;
  }

  List<UnreadMessage> getUnreadMessageListBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      Iterable list = json.decode(httpResponse.body);
      List<UnreadMessage> unreadMessageList = list.map((model) => UnreadMessage.fromJson(model)).toList();
      return unreadMessageList;
    }
    return null;
  }
}
