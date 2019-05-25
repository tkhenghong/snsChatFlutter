// No enum in Dart native yet
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

class Conversation {
  // Single conversation, group conversation & broadcast channel
  String id;
  String name;
  ChatGroupType type;
  String groupPhotoId; // Multimedia
  String unreadMessageId; // UnreadMessage
  String description;
  bool block;
  int notificationExpireDate; // 0 means notifications not blocked, > 0 means notifications are blocked until specified time.
  List<UserContact> contacts;

  Conversation(
      {this.id,
      this.name,
      this.type,
      this.groupPhotoId,
      this.unreadMessageId,
      this.block,
      this.description,
      this.notificationExpireDate,
      this.contacts});

  Conversation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        groupPhotoId = json['groupPhotoId'],
        unreadMessageId = json['unreadMessageId'],
        block = json['block'],
        description = json['description'],
        notificationExpireDate = json['notificationExpireDate'],
        contacts = json['contacts'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'groupPhotoId': groupPhotoId,
        'unreadMessageId': unreadMessageId,
        'block': block,
        'description': description,
        'notificationExpireDate': notificationExpireDate,
        'contacts': contacts,
      };
}

class UnreadMessage {
  String id;
  String lastMessage;
  int date;
  int count;

  UnreadMessage({this.id, this.lastMessage, this.date, this.count});

  UnreadMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastMessage = json['lastMessage'],
        date = json['date'],
        count = json['count'];

  Map<String, dynamic> toJson() => {'id': id, 'lastMessage': lastMessage, 'date': date, 'count': count};
}

// Save the message using files as backup, normally just save the conversations' messages in Message table
// Update lastseen if single conversation, Update members and how many people online if group conversation, update subscribers if broadcast
