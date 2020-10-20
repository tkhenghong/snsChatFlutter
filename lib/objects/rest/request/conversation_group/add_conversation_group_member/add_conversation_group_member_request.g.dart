// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_conversation_group_member_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddConversationGroupMemberRequest _$AddConversationGroupMemberRequestFromJson(
    Map<String, dynamic> json) {
  return AddConversationGroupMemberRequest(
    groupMemberIds:
        (json['groupMemberIds'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$AddConversationGroupMemberRequestToJson(
        AddConversationGroupMemberRequest instance) =>
    <String, dynamic>{
      'groupMemberIds': instance.groupMemberIds,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$AddConversationGroupMemberRequestLombok {
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
