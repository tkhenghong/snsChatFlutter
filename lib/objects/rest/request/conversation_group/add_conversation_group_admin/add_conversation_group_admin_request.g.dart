// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_conversation_group_admin_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddConversationGroupAdminRequest _$AddConversationGroupAdminRequestFromJson(
    Map<String, dynamic> json) {
  return AddConversationGroupAdminRequest(
    groupMemberIds:
        (json['groupMemberIds'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$AddConversationGroupAdminRequestToJson(
        AddConversationGroupAdminRequest instance) =>
    <String, dynamic>{
      'groupMemberIds': instance.groupMemberIds,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$AddConversationGroupAdminRequestLombok {
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
