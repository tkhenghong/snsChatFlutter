// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_conversation_group_member_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveConversationGroupMemberRequest
    _$RemoveConversationGroupMemberRequestFromJson(Map<String, dynamic> json) {
  return RemoveConversationGroupMemberRequest(
    groupMemberIds:
        (json['groupMemberIds'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$RemoveConversationGroupMemberRequestToJson(
        RemoveConversationGroupMemberRequest instance) =>
    <String, dynamic>{
      'groupMemberIds': instance.groupMemberIds,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$RemoveConversationGroupMemberRequestLombok {
  /// Field
  List<String> groupMemberIds;

  /// Setter

  void setGroupMemberIds(List<String> groupMemberIds) {
    this.groupMemberIds = groupMemberIds;
  }

  /// Getter
  List<String> getGroupMemberIds() {
    return groupMemberIds;
  }
}
