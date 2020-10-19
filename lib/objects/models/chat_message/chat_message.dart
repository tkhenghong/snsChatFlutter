import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/enums/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'chat_message.g.dart';

@data
@JsonSerializable()
class ChatMessage extends Auditable {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'conversationId')
  String conversationId;

  @JsonKey(name: 'senderId')
  String senderId;

  @JsonKey(name: 'senderName')
  String senderName;

  @JsonKey(name: 'senderMobileNo')
  String senderMobileNo;

  @JsonKey(name: 'status')
  ChatMessageStatus status;

  @JsonKey(name: 'messageContent')
  String messageContent;

  @JsonKey(name: 'multimediaId')
  String multimediaId;

  ChatMessage(
      {this.id,
      this.conversationId,
      this.senderId,
      this.senderName,
      this.senderMobileNo,
      this.status,
      this.messageContent,
      this.multimediaId});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
