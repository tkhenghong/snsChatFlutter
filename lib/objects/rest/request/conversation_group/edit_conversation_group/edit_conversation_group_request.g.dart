// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_conversation_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditConversationGroupRequest _$EditConversationGroupRequestFromJson(
    Map<String, dynamic> json) {
  return EditConversationGroupRequest(
    name: json['name'] as String,
    description: json['description'] as String,
  )..id = json['id'] as String;
}

Map<String, dynamic> _$EditConversationGroupRequestToJson(
        EditConversationGroupRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$EditConversationGroupRequestLombok {
  /// Field
  String id;
  String name;
  String description;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setDescription(String description) {
    this.description = description;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getName() {
    return name;
  }

  String getDescription() {
    return description;
  }
}
