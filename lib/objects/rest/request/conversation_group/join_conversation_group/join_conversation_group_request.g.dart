// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_conversation_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinConversationGroupRequest _$JoinConversationGroupRequestFromJson(
    Map<String, dynamic> json) {
  return JoinConversationGroupRequest(
    inviteCode: json['inviteCode'] as String,
  );
}

Map<String, dynamic> _$JoinConversationGroupRequestToJson(
        JoinConversationGroupRequest instance) =>
    <String, dynamic>{
      'inviteCode': instance.inviteCode,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$JoinConversationGroupRequestLombok {
  /// Field
  String inviteCode;

  /// Setter

  void setInviteCode(String inviteCode) {
    this.inviteCode = inviteCode;
  }

  /// Getter
  String getInviteCode() {
    return inviteCode;
  }
}
