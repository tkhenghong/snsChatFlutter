// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_chat_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChatMessageRequest _$CreateChatMessageRequestFromJson(
    Map<String, dynamic> json) {
  return CreateChatMessageRequest(
    conversationId: json['conversationId'] as String,
    messageContent: json['messageContent'] as String,
  );
}

Map<String, dynamic> _$CreateChatMessageRequestToJson(
        CreateChatMessageRequest instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageContent': instance.messageContent,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$CreateChatMessageRequestLombok {
  /// Field
  String conversationId;
  String messageContent;

  /// Setter

  void setConversationId(String conversationId) {
    this.conversationId = conversationId;
  }

  void setMessageContent(String messageContent) {
    this.messageContent = messageContent;
  }

  /// Getter
  String getConversationId() {
    return conversationId;
  }

  String getMessageContent() {
    return messageContent;
  }
}
