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
        : Page.fromJson(
            json['conversationGroupResponses'] as Map<String, dynamic>),
    unreadMessageResponses: json['unreadMessageResponses'] == null
        ? null
        : Page.fromJson(json['unreadMessageResponses'] as Map<String, dynamic>),
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
  Page conversationGroupResponses;
  Page unreadMessageResponses;

  /// Setter

  void setConversationGroupResponses(Page conversationGroupResponses) {
    this.conversationGroupResponses = conversationGroupResponses;
  }

  void setUnreadMessageResponses(Page unreadMessageResponses) {
    this.unreadMessageResponses = unreadMessageResponses;
  }

  /// Getter
  Page getConversationGroupResponses() {
    return conversationGroupResponses;
  }

  Page getUnreadMessageResponses() {
    return unreadMessageResponses;
  }
}
