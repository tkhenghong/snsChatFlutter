// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group_mute_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationGroupMuteNotification _$ConversationGroupMuteNotificationFromJson(
    Map<String, dynamic> json) {
  return ConversationGroupMuteNotification(
    id: json['id'] as String,
    userContactId: json['userContactId'] as String,
    conversationGroupId: json['conversationGroupId'] as String,
    notificationBlockExpire: json['notificationBlockExpire'] == null
        ? null
        : DateTime.parse(json['notificationBlockExpire'] as String),
  );
}

Map<String, dynamic> _$ConversationGroupMuteNotificationToJson(
        ConversationGroupMuteNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userContactId': instance.userContactId,
      'conversationGroupId': instance.conversationGroupId,
      'notificationBlockExpire':
          instance.notificationBlockExpire?.toIso8601String(),
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$ConversationGroupMuteNotificationLombok {
  /// Field
  String id;
  String userContactId;
  String conversationGroupId;
  DateTime notificationBlockExpire;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setUserContactId(String userContactId) {
    this.userContactId = userContactId;
  }

  void setConversationGroupId(String conversationGroupId) {
    this.conversationGroupId = conversationGroupId;
  }

  void setNotificationBlockExpire(DateTime notificationBlockExpire) {
    this.notificationBlockExpire = notificationBlockExpire;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getUserContactId() {
    return userContactId;
  }

  String getConversationGroupId() {
    return conversationGroupId;
  }

  DateTime getNotificationBlockExpire() {
    return notificationBlockExpire;
  }
}
