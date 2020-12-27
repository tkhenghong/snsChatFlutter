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
    chatMessageStatus: _$enumDecodeNullable(
        _$ChatMessageStatusEnumMap, json['chatMessageStatus']),
    messageContent: json['messageContent'] as String,
    multimediaId: json['multimediaId'] as String,
  )
    ..createdBy = json['createdBy'] as String
    ..createdDate = json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String)
    ..lastModifiedBy = json['lastModifiedBy'] as String
    ..lastModifiedDate = json['lastModifiedDate'] == null
        ? null
        : DateTime.parse(json['lastModifiedDate'] as String)
    ..version = json['version'] as int;
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderMobileNo': instance.senderMobileNo,
      'chatMessageStatus':
          _$ChatMessageStatusEnumMap[instance.chatMessageStatus],
      'messageContent': instance.messageContent,
      'multimediaId': instance.multimediaId,
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
  String senderId;
  String senderName;
  String senderMobileNo;
  ChatMessageStatus chatMessageStatus;
  String messageContent;
  String multimediaId;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setConversationId(String conversationId) {
    this.conversationId = conversationId;
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

  void setChatMessageStatus(ChatMessageStatus chatMessageStatus) {
    this.chatMessageStatus = chatMessageStatus;
  }

  void setMessageContent(String messageContent) {
    this.messageContent = messageContent;
  }

  void setMultimediaId(String multimediaId) {
    this.multimediaId = multimediaId;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getConversationId() {
    return conversationId;
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

  ChatMessageStatus getChatMessageStatus() {
    return chatMessageStatus;
  }

  String getMessageContent() {
    return messageContent;
  }

  String getMultimediaId() {
    return multimediaId;
  }
}
