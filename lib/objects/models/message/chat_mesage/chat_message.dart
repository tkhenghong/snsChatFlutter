import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/enums/index.dart';

part 'chat_message.g.dart';

@data
@JsonSerializable()
class ChatMessage {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'conversationId')
  String conversationId;

  @JsonKey(name: 'type')
  ChatMessageType type;

  @JsonKey(name: 'status')
  ChatMessageStatus status;

  @JsonKey(name: 'messageContent')
  String messageContent;

  @JsonKey(name: 'multimediaId')
  String multimediaId;

  // Sender
  @JsonKey(name: 'senderId')
  String senderId; // UserContactId

  @JsonKey(name: 'senderName')
  String senderName;

  @JsonKey(name: 'senderMobileNo')
  String senderMobileNo;

  // Receiver
  @JsonKey(name: 'receiverId')
  String receiverId; // UserContactId

  @JsonKey(name: 'receiverName')
  String receiverName;

  @JsonKey(name: 'receiverMobileNo')
  String receiverMobileNo;

  @JsonKey(name: 'createdTime')
  DateTime createdTime;

  @JsonKey(name: 'sentTime')
  DateTime sentTime;

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

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
