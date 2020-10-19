// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_conversation_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateConversationGroupRequest _$CreateConversationGroupRequestFromJson(
    Map<String, dynamic> json) {
  return CreateConversationGroupRequest(
    name: json['name'] as String,
    conversationGroupType: _$enumDecodeNullable(
        _$ConversationGroupTypeEnumMap, json['conversationGroupType']),
    description: json['description'] as String,
    memberIds: (json['memberIds'] as List)?.map((e) => e as String)?.toList(),
    adminMemberIds:
        (json['adminMemberIds'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$CreateConversationGroupRequestToJson(
        CreateConversationGroupRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'conversationGroupType':
          _$ConversationGroupTypeEnumMap[instance.conversationGroupType],
      'description': instance.description,
      'memberIds': instance.memberIds,
      'adminMemberIds': instance.adminMemberIds,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ConversationGroupTypeEnumMap = {
  ConversationGroupType.Personal: 'Personal',
  ConversationGroupType.Group: 'Group',
  ConversationGroupType.Broadcast: 'Broadcast',
};

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$CreateConversationGroupRequestLombok {
  /// Field
  String name;
  ConversationGroupType conversationGroupType;
  String description;
  List<String> memberIds;
  List<String> adminMemberIds;

  /// Setter

  void setName(String name) {
    this.name = name;
  }

  void setConversationGroupType(ConversationGroupType conversationGroupType) {
    this.conversationGroupType = conversationGroupType;
  }

  void setDescription(String description) {
    this.description = description;
  }

  void setMemberIds(List<String> memberIds) {
    this.memberIds = memberIds;
  }

  void setAdminMemberIds(List<String> adminMemberIds) {
    this.adminMemberIds = adminMemberIds;
  }

  /// Getter
  String getName() {
    return name;
  }

  ConversationGroupType getConversationGroupType() {
    return conversationGroupType;
  }

  String getDescription() {
    return description;
  }

  List<String> getMemberIds() {
    return memberIds;
  }

  List<String> getAdminMemberIds() {
    return adminMemberIds;
  }
}
