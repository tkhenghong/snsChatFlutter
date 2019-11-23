import 'dart:convert';

import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/conversationGroup/conversation_group.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/objects/settings/settings.dart';
import 'package:snschat_flutter/objects/unreadMessage/UnreadMessage.dart';
import 'package:snschat_flutter/objects/user/user.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

class WebSocketMessage {
  ConversationGroup conversationGroup;
  Message message;
  Multimedia multimedia;
  Settings settings;
  UnreadMessage unreadMessage;
  User user;
  UserContact userContact;

  WebSocketMessage({this.conversationGroup, this.message, this.multimedia, this.settings, this.unreadMessage, this.user, this.userContact});

  factory WebSocketMessage.fromJson(Map<String, dynamic> jsonBody) {
    WebSocketMessage webSocketMessage = WebSocketMessage();
    var conversationGroupFromJson = jsonBody['conversationGroup'];
    var messageFromJson = jsonBody['message'];
    var multimediaFromJson = jsonBody['multimedia'];
    var settingsFromJson = jsonBody['settings'];
    var unreadMessageFromJson = jsonBody['unreadMessage'];
    var userFromJson = jsonBody['user'];
    var userContactFromJson = jsonBody['userContact'];

    webSocketMessage.conversationGroup =
        isStringEmpty(conversationGroupFromJson) ? null : ConversationGroup.fromJson(json.decode(conversationGroupFromJson));
    webSocketMessage.message = isStringEmpty(messageFromJson) ? null : Message.fromJson(json.decode(messageFromJson));
    webSocketMessage.multimedia = isStringEmpty(multimediaFromJson) ? null : Multimedia.fromJson(json.decode(multimediaFromJson));
    webSocketMessage.settings = isStringEmpty(settingsFromJson) ? null : Settings.fromJson(json.decode(settingsFromJson));
    webSocketMessage.unreadMessage =
        isStringEmpty(unreadMessageFromJson) ? null : UnreadMessage.fromJson(json.decode(unreadMessageFromJson));
    webSocketMessage.user = isStringEmpty(userFromJson) ? null : User.fromJson(json.decode(userFromJson));
    webSocketMessage.userContact = isStringEmpty(userContactFromJson) ? null : UserContact.fromJson(json.decode(userContactFromJson));

    return webSocketMessage;
  }

  Map<String, dynamic> toJson() => {
        'conversationGroup': isObjectEmpty(conversationGroup) ? null : json.encode(conversationGroup.toJson()),
        'message': isObjectEmpty(message) ? null : json.encode(message.toJson()),
        'multimedia': isObjectEmpty(multimedia) ? null : json.encode(multimedia.toJson()),
        'settings': isObjectEmpty(settings) ? null : json.encode(settings.toJson()),
        'unreadMessage': isObjectEmpty(unreadMessage) ? null : json.encode(unreadMessage.toJson()),
        'user': isObjectEmpty(user) ? null : json.encode(user.toJson()),
        'userContact': isObjectEmpty(userContact) ? null : json.encode(userContact.toJson()),
      };
}
