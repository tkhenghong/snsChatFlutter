// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unmute_conversation_group_notification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnmuteConversationGroupNotificationRequest
    _$UnmuteConversationGroupNotificationRequestFromJson(
        Map<String, dynamic> json) {
  return UnmuteConversationGroupNotificationRequest(
    conversationGroupMuteNotificationId:
        json['conversationGroupMuteNotificationId'] as String,
  );
}

Map<String, dynamic> _$UnmuteConversationGroupNotificationRequestToJson(
        UnmuteConversationGroupNotificationRequest instance) =>
    <String, dynamic>{
      'conversationGroupMuteNotificationId':
          instance.conversationGroupMuteNotificationId,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UnmuteConversationGroupNotificationRequestLombok {
  /// Field
  String conversationGroupMuteNotificationId;

  /// Setter

  void setConversationGroupMuteNotificationId(
      String conversationGroupMuteNotificationId) {
    this.conversationGroupMuteNotificationId =
        conversationGroupMuteNotificationId;
  }

  /// Getter
  String getConversationGroupMuteNotificationId() {
    return conversationGroupMuteNotificationId;
  }
}
