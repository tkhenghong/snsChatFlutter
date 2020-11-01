// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_pageable_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationPageableResponse _$ConversationPageableResponseFromJson(
    Map<String, dynamic> json) {
  return ConversationPageableResponse(
    conversationGroupResponses: json['conversationGroupResponses'] == null
        ? null
        : PageInfo.fromJson(
            json['conversationGroupResponses'] as Map<String, dynamic>),
    unreadMessageResponses: json['unreadMessageResponses'] == null
        ? null
        : PageInfo.fromJson(
            json['unreadMessageResponses'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConversationPageableResponseToJson(
        ConversationPageableResponse instance) =>
    <String, dynamic>{
      'conversationGroupResponses': instance.conversationGroupResponses,
      'unreadMessageResponses': instance.unreadMessageResponses,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$ConversationPageableResponseLombok {
  /// Field
  PageInfo conversationGroupResponses;
  PageInfo unreadMessageResponses;

  /// Setter

  void setConversationGroupResponses(PageInfo conversationGroupResponses) {
    this.conversationGroupResponses = conversationGroupResponses;
  }

  void setUnreadMessageResponses(PageInfo unreadMessageResponses) {
    this.unreadMessageResponses = unreadMessageResponses;
  }

  /// Getter
  PageInfo getConversationGroupResponses() {
    return conversationGroupResponses;
  }

  PageInfo getUnreadMessageResponses() {
    return unreadMessageResponses;
  }
}
