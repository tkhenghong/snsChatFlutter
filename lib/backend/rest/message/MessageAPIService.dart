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

  addMessage(Message message) async {

  }

  editMessage() async {}

  deleteMessage() async {}

  getMessagesOfAConversation() async {}
}
