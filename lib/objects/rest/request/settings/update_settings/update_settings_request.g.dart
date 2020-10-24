// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateSettingsRequest _$UpdateSettingsRequestFromJson(
    Map<String, dynamic> json) {
  return UpdateSettingsRequest(
    id: json['id'] as String,
    allowNotifications: json['allowNotifications'] as String,
  );
}

Map<String, dynamic> _$UpdateSettingsRequestToJson(
        UpdateSettingsRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'allowNotifications': instance.allowNotifications,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UpdateSettingsRequestLombok {
  /// Field
  String id;
  String allowNotifications;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setAllowNotifications(String allowNotifications) {
    this.allowNotifications = allowNotifications;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getAllowNotifications() {
    return allowNotifications;
  }
}
