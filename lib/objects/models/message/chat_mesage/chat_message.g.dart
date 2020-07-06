// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return ChatMessage(
    id: json['id'] as String,
    conversationId: json['conversationId'] as String,
    senderId: json['senderId'] as String,
    senderName: json['senderName'] as String,
    senderMobileNo: json['senderMobileNo'] as String,
    receiverId: json['receiverId'] as String,
    receiverName: json['receiverName'] as String,
    receiverMobileNo: json['receiverMobileNo'] as String,
    type: _$enumDecodeNullable(_$ChatMessageTypeEnumMap, json['type']),
    status: _$enumDecodeNullable(_$ChatMessageStatusEnumMap, json['status']),
    messageContent: json['messageContent'] as String,
    multimediaId: json['multimediaId'] as String,
    createdTime: json['createdTime'] == null
        ? null
        : DateTime.parse(json['createdTime'] as String),
    sentTime: json['sentTime'] == null
        ? null
        : DateTime.parse(json['sentTime'] as String),
  );
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'type': _$ChatMessageTypeEnumMap[instance.type],
      'status': _$ChatMessageStatusEnumMap[instance.status],
      'messageContent': instance.messageContent,
      'multimediaId': instance.multimediaId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderMobileNo': instance.senderMobileNo,
      'receiverId': instance.receiverId,
      'receiverName': instance.receiverName,
      'receiverMobileNo': instance.receiverMobileNo,
      'createdTime': instance.createdTime?.toIso8601String(),
      'sentTime': instance.sentTime?.toIso8601String(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ChatMessageTypeEnumMap = {
  ChatMessageType.Text: 'Text',
  ChatMessageType.Image: 'Image',
  ChatMessageType.Video: 'Video',
  ChatMessageType.Audio: 'Audio',
  ChatMessageType.Recording: 'Recording',
  ChatMessageType.Document: 'Document',
  ChatMessageType.File: 'File',
};

const _$ChatMessageStatusEnumMap = {
  ChatMessageStatus.Sending: 'Sending',
  ChatMessageStatus.Sent: 'Sent',
  ChatMessageStatus.Received: 'Received',
  ChatMessageStatus.Read: 'Read',
};

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$ChatMessageLombok {
  /// Field
  String id;
  String conversationId;
  ChatMessageType type;
  ChatMessageStatus status;
  String messageContent;
  String multimediaId;
  String senderId;
  String senderName;
  String senderMobileNo;
  String receiverId;
  String receiverName;
  String receiverMobileNo;
  DateTime createdTime;
  DateTime sentTime;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setConversationId(String conversationId) {
    this.conversationId = conversationId;
  }

  void setType(ChatMessageType type) {
    this.type = type;
  }

  void setStatus(ChatMessageStatus status) {
    this.status = status;
  }

  void setMessageContent(String messageContent) {
    this.messageContent = messageContent;
  }

  void setMultimediaId(String multimediaId) {
    this.multimediaId = multimediaId;
  }

  void setSenderId(String senderId) {
    this.senderId = senderId;
  }

  void setSenderName(String senderName) {
    this.senderName = senderName;
  }

  void setSenderMobileNo(String senderMobileNo) {
    this.senderMobileNo = senderMobileNo;
  }

  void setReceiverId(String receiverId) {
    this.receiverId = receiverId;
  }

  void setReceiverName(String receiverName) {
    this.receiverName = receiverName;
  }

  void setReceiverMobileNo(String receiverMobileNo) {
    this.receiverMobileNo = receiverMobileNo;
  }

  void setCreatedTime(DateTime createdTime) {
    this.createdTime = createdTime;
  }

  void setSentTime(DateTime sentTime) {
    this.sentTime = sentTime;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getConversationId() {
    return conversationId;
  }

  ChatMessageType getType() {
    return type;
  }

  ChatMessageStatus getStatus() {
    return status;
  }

  String getMessageContent() {
    return messageContent;
  }

  String getMultimediaId() {
    return multimediaId;
  }

  String getSenderId() {
    return senderId;
  }

  String getSenderName() {
    return senderName;
  }

  String getSenderMobileNo() {
    return senderMobileNo;
  }

  String getReceiverId() {
    return receiverId;
  }

  String getReceiverName() {
    return receiverName;
  }

  String getReceiverMobileNo() {
    return receiverMobileNo;
  }

  DateTime getCreatedTime() {
    return createdTime;
  }

  DateTime getSentTime() {
    return sentTime;
  }
}
