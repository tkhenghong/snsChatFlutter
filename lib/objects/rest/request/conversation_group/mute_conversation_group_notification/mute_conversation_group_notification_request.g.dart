// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_conversation_group_notification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteConversationGroupNotificationRequest
    _$MuteConversationGroupNotificationRequestFromJson(
        Map<String, dynamic> json) {
  return MuteConversationGroupNotificationRequest(
    blockNotificationExpireTime: json['blockNotificationExpireTime'] == null
        ? null
        : DateTime.parse(json['blockNotificationExpireTime'] as String),
  );
}

Map<String, dynamic> _$MuteConversationGroupNotificationRequestToJson(
        MuteConversationGroupNotificationRequest instance) =>
    <String, dynamic>{
      'blockNotificationExpireTime':
          instance.blockNotificationExpireTime?.toIso8601String(),
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MuteConversationGroupNotificationRequestLombok {
  /// Field
  DateTime blockNotificationExpireTime;

  /// Setter

  void setBlockNotificationExpireTime(DateTime blockNotificationExpireTime) {
    this.blockNotificationExpireTime = blockNotificationExpireTime;
  }

  /// Getter
  DateTime getBlockNotificationExpireTime() {
    return blockNotificationExpireTime;
  }
}
