import 'package:lombok/lombok.dart';

import 'package:snschat_flutter/general/enums/index.dart';

@data
class ChatMessage {
  String id;
  String conversationId;
  ChatMessageType type;
  ChatMessageStatus status;
  String messageContent;
  String multimediaId;

  // Sender
  String senderId; // UserContactId
  String senderName;
  String senderMobileNo;

  // Receiver
  String receiverId; // UserContactId
  String receiverName;
  String receiverMobileNo;

  int createdTime;
  int sentTime;

  ChatMessage(
      {this.id,
      this.conversationId,
      this.senderId,
      this.senderName,
      this.senderMobileNo,
      this.receiverId,
      this.receiverName,
      this.receiverMobileNo,
      this.type,
      this.status,
      this.messageContent,
      this.multimediaId,
      this.createdTime,
      this.sentTime});

  ChatMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        conversationId = json['conversationId'],
        senderId = json['senderId'],
        senderName = json['senderName'],
        senderMobileNo = json['senderMobileNo'],
        receiverId = json['receiverId'],
        receiverName = json['receiverName'],
        receiverMobileNo = json['receiverMobileNo'],
        type = json['type'],
        status = json['status'],
        messageContent = json['messageContent'],
        multimediaId = json['multimediaId'],
        createdTime = json['createdTime'],
        sentTime = json['sentTime'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'senderName': senderName,
        'senderMobileNo': senderMobileNo,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'receiverMobileNo': receiverMobileNo,
        'type': type,
        'status': status,
        'messageContent': messageContent,
        'multimediaId': multimediaId,
        'createdTime': createdTime,
        'sentTime': sentTime,
      };
}
