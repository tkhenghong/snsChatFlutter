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
  );
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
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
