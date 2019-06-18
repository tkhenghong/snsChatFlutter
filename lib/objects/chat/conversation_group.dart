// No enum in Dart native yet
import 'package:snschat_flutter/enums/chat_group/chat_group.dart';
import 'package:snschat_flutter/general/functions/repeating_functions.dart';
import 'package:snschat_flutter/objects/userContact/userContact.dart';

class Conversation {
  // Single conversation, group conversation & broadcast channel
  String id;
  String userId;
  String name;
  String type;
  String groupPhotoId; // Multimedia
  String unreadMessageId; // UnreadMessage
  String description;
  bool block;
  int notificationExpireDate; // 0 means notifications not blocked, > 0 means notifications are blocked until specified time.
//  List<UserContact> contacts;
  String timestamp;

  Conversation(
      {this.id,
      this.userId,
      this.name,
      this.type,
      this.groupPhotoId,
      this.unreadMessageId,
      this.block,
      this.description,
      this.notificationExpireDate,
      this.timestamp});

  Conversation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        name = json['name'],
        type = json['type'],
        groupPhotoId = json['groupPhotoId'],
        unreadMessageId = json['unreadMessageId'],
        block = json['block'],
        description = json['description'],
        notificationExpireDate = json['notificationExpireDate'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'type': type,
        'groupPhotoId': groupPhotoId,
        'unreadMessageId': unreadMessageId,
        'block': block,
        'description': description,
        'notificationExpireDate': notificationExpireDate,
        'timestamp': timestamp,
      };
}

class UnreadMessage {
  String id;
  String conversationId;
  String lastMessage;
  int date;
  int count;

  UnreadMessage({this.id, this.conversationId, this.lastMessage, this.date, this.count});

  UnreadMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        conversationId = json['conversationId'],
        lastMessage = json['lastMessage'],
        date = json['date'],
        count = json['count'];

  Map<String, dynamic> toJson() => {'id': id, 'conversationId': conversationId, 'lastMessage': lastMessage, 'date': date, 'count': count};
}

// Save the message using files as backup, normally just save the conversations' messages in Message table
// Update lastseen if single conversation, Update members and how many people online if group conversation, update subscribers if broadcast
