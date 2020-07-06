// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationGroup _$ConversationGroupFromJson(Map<String, dynamic> json) {
  return ConversationGroup(
    id: json['id'] as String,
    creatorUserId: json['creatorUserId'] as String,
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$ConversationGroupTypeEnumMap, json['type']),
    block: json['block'] as bool,
    description: json['description'] as String,
    memberIds: (json['memberIds'] as List)?.map((e) => e as String)?.toList(),
    adminMemberIds:
        (json['adminMemberIds'] as List)?.map((e) => e as String)?.toList(),
    notificationExpireDate: json['notificationExpireDate'] == null
        ? null
        : DateTime.parse(json['notificationExpireDate'] as String),
  );
}

Map<String, dynamic> _$ConversationGroupToJson(ConversationGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorUserId': instance.creatorUserId,
      'createdDate': instance.createdDate?.toIso8601String(),
      'name': instance.name,
      'type': _$ConversationGroupTypeEnumMap[instance.type],
      'description': instance.description,
      'memberIds': instance.memberIds,
      'adminMemberIds': instance.adminMemberIds,
      'block': instance.block,
      'notificationExpireDate':
          instance.notificationExpireDate?.toIso8601String(),
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
  DateTime createdDate;
  String name;
  ConversationGroupType type;
  String description;
  List<String> memberIds;
  List<String> adminMemberIds;
  bool block;
  DateTime notificationExpireDate;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setCreatorUserId(String creatorUserId) {
    this.creatorUserId = creatorUserId;
  }

  void setCreatedDate(DateTime createdDate) {
    this.createdDate = createdDate;
  }

  void setName(String name) {
    this.name = name;
  }

  void setType(ConversationGroupType type) {
    this.type = type;
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

  void setBlock(bool block) {
    this.block = block;
  }

  void setNotificationExpireDate(DateTime notificationExpireDate) {
    this.notificationExpireDate = notificationExpireDate;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getCreatorUserId() {
    return creatorUserId;
  }

  DateTime getCreatedDate() {
    return createdDate;
  }

  String getName() {
    return name;
  }

  ConversationGroupType getType() {
    return type;
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

  bool getBlock() {
    return block;
  }

  DateTime getNotificationExpireDate() {
    return notificationExpireDate;
  }
}
