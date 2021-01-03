// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
    id: json['id'] as String,
    userId: json['userId'] as String,
    allowNotifications: json['allowNotifications'] as bool,
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

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
      'id': instance.id,
      'userId': instance.userId,
      'allowNotifications': instance.allowNotifications,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$SettingsLombok {
  /// Field
  String id;
  String userId;
  bool allowNotifications;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setUserId(String userId) {
    this.userId = userId;
  }

  void setAllowNotifications(bool allowNotifications) {
    this.allowNotifications = allowNotifications;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getUserId() {
    return userId;
  }

  bool getAllowNotifications() {
    return allowNotifications;
  }
}
