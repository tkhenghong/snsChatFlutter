// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_conversation_group_admin_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveConversationGroupAdminRequest
    _$RemoveConversationGroupAdminRequestFromJson(Map<String, dynamic> json) {
  return RemoveConversationGroupAdminRequest(
    groupMemberIds:
        (json['groupMemberIds'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$RemoveConversationGroupAdminRequestToJson(
        RemoveConversationGroupAdminRequest instance) =>
    <String, dynamic>{
      'groupMemberIds': instance.groupMemberIds,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$RemoveConversationGroupAdminRequestLombok {
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
