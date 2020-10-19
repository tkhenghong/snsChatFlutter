// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationGroup _$ConversationGroupFromJson(Map<String, dynamic> json) {
  return ConversationGroup(
    id: json['id'] as String,
    conversationGroupType: _$enumDecodeNullable(
        _$ConversationGroupTypeEnumMap, json['conversationGroupType']),
    creatorUserId: json['creatorUserId'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    memberIds: (json['memberIds'] as List)?.map((e) => e as String)?.toList(),
    adminMemberIds:
        (json['adminMemberIds'] as List)?.map((e) => e as String)?.toList(),
    groupPhoto: json['groupPhoto'] as String,
  )
    ..createdBy = json['createdBy'] as String
    ..createdDate = json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String)
    ..lastModifiedBy = json['lastModifiedBy'] as String
    ..lastModifiedDate = json['lastModifiedDate'] == null
        ? null
        : DateTime.parse(json['lastModifiedDate'] as String)
    ..version = json['version'] as int;
}

Map<String, dynamic> _$ConversationGroupToJson(ConversationGroup instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
      'id': instance.id,
      'creatorUserId': instance.creatorUserId,
      'name': instance.name,
      'conversationGroupType':
          _$ConversationGroupTypeEnumMap[instance.conversationGroupType],
      'description': instance.description,
      'memberIds': instance.memberIds,
      'adminMemberIds': instance.adminMemberIds,
      'groupPhoto': instance.groupPhoto,
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

abstract class _$ConversationGroupLombok {
  /// Field
  String id;
  String creatorUserId;
  String name;
  ConversationGroupType conversationGroupType;
  String description;
  List<String> memberIds;
  List<String> adminMemberIds;
  String groupPhoto;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setCreatorUserId(String creatorUserId) {
    this.creatorUserId = creatorUserId;
  }

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

  void setGroupPhoto(String groupPhoto) {
    this.groupPhoto = groupPhoto;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getCreatorUserId() {
    return creatorUserId;
  }

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

  String getGroupPhoto() {
    return groupPhoto;
  }
}
