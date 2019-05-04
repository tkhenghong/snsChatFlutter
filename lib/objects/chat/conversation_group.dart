// No enum in Dart native yet
import 'package:snschat_flutter/objects/contact/contact.dart';
import 'package:snschat_flutter/objects/message/message.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

class Conversation {
  // Single conversation, group conversation & broadcast channel
  String id;
  String name;
  String type;
  Multimedia groupPhoto;
  String description;
  bool block;
  int notificationExpireDate; // 0 means notifications not blocked, > 0 means notifications are blocked until specified time.
  List<UserContact> contacts;
  UnreadMessage unreadMessage;

  Conversation(
      {this.id,
      this.name,
      this.type,
      this.groupPhoto,
      this.unreadMessage,
      this.block,
      this.description,
      this.notificationExpireDate,
      this.contacts});
}

// Save the message using files as backup, normally just save the conversations' messages in Message table
// Update lastseen if single conversation, Update members and how many people online if group conversation, update subscribers if broadcast
