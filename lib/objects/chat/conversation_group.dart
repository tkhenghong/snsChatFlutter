// No enum in Dart native yet
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class Conversation { // Single conversation, group conversation & broadcast channel
  String id;
  String name;
  String type;
  Multimedia multimedia;
  String description;
  bool block;
  int notificationExpireDate; // 0 means notifications not blocked, > 0 means notifications are blocked until specified time.
  UnreadMessage unreadMessage;
  Conversation({this.id, this.name, this.type, this.multimedia, this.unreadMessage, this.block, this.description, this.notificationExpireDate});
}

// Save the message using files as backup, normally just save the conversations' messages in Message table
// Update lastseen if single conversation, Update members and how many people online if group conversation, update subscribers if broadcast
