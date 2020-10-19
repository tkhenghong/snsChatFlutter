// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_group_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationGroupBlock _$ConversationGroupBlockFromJson(
    Map<String, dynamic> json) {
  return ConversationGroupBlock(
    id: json['id'] as String,
    userContactId: json['userContactId'] as String,
    conversationGroupId: json['conversationGroupId'] as String,
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

Map<String, dynamic> _$ConversationGroupBlockToJson(
        ConversationGroupBlock instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
      'id': instance.id,
      'userContactId': instance.userContactId,
      'conversationGroupId': instance.conversationGroupId,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$ConversationGroupBlockLombok {
  /// Field
  String id;
  String userContactId;
  String conversationGroupId;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setUserContactId(String userContactId) {
    this.userContactId = userContactId;
  }

  void setConversationGroupId(String conversationGroupId) {
    this.conversationGroupId = conversationGroupId;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getUserContactId() {
    return userContactId;
  }

  String getConversationGroupId() {
    return conversationGroupId;
  }
}
