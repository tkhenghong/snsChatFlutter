// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadMessage _$UnreadMessageFromJson(Map<String, dynamic> json) {
  return UnreadMessage(
    id: json['id'] as String,
    userId: json['userId'] as String,
    conversationId: json['conversationId'] as String,
    lastMessage: json['lastMessage'] as String,
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$UnreadMessageToJson(UnreadMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'lastMessage': instance.lastMessage,
      'count': instance.count,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UnreadMessageLombok {
  /// Field
  String id;
  String conversationId;
  String userId;
  String lastMessage;
  int count;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setConversationId(String conversationId) {
    this.conversationId = conversationId;
  }

  void setUserId(String userId) {
    this.userId = userId;
  }

  void setLastMessage(String lastMessage) {
    this.lastMessage = lastMessage;
  }

  void setCount(int count) {
    this.count = count;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getConversationId() {
    return conversationId;
  }

  String getUserId() {
    return userId;
  }

  String getLastMessage() {
    return lastMessage;
  }

  int getCount() {
    return count;
  }
}
