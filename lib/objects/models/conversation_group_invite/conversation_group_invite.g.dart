// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationGroupInvite _$ConversationGroupInviteFromJson(
    Map<String, dynamic> json) {
  return ConversationGroupInvite(
    id: json['id'] as String,
    conversationGroupId: json['conversationGroupId'] as String,
    invitationExpireTime: json['invitationExpireTime'] == null
        ? null
        : DateTime.parse(json['invitationExpireTime'] as String),
    secretInvitationKey: json['secretInvitationKey'] as String,
    invitesRemaining: json['invitesRemaining'] as int,
  );
}

Map<String, dynamic> _$ConversationGroupInviteToJson(
        ConversationGroupInvite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationGroupId': instance.conversationGroupId,
      'invitationExpireTime': instance.invitationExpireTime?.toIso8601String(),
      'secretInvitationKey': instance.secretInvitationKey,
      'invitesRemaining': instance.invitesRemaining,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$ConversationGroupInviteLombok {
  /// Field
  String id;
  String conversationGroupId;
  DateTime invitationExpireTime;
  String secretInvitationKey;
  int invitesRemaining;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setConversationGroupId(String conversationGroupId) {
    this.conversationGroupId = conversationGroupId;
  }

  void setInvitationExpireTime(DateTime invitationExpireTime) {
    this.invitationExpireTime = invitationExpireTime;
  }

  void setSecretInvitationKey(String secretInvitationKey) {
    this.secretInvitationKey = secretInvitationKey;
  }

  void setInvitesRemaining(int invitesRemaining) {
    this.invitesRemaining = invitesRemaining;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getConversationGroupId() {
    return conversationGroupId;
  }

  DateTime getInvitationExpireTime() {
    return invitationExpireTime;
  }

  String getSecretInvitationKey() {
    return secretInvitationKey;
  }

  int getInvitesRemaining() {
    return invitesRemaining;
  }
}
