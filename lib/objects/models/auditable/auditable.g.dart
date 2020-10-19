// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditable _$AuditableFromJson(Map<String, dynamic> json) {
  return Auditable(
    createdBy: json['createdBy'] as String,
    createdDate: json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String),
    lastModifiedBy: json['lastModifiedBy'] as String,
    lastModifiedDate: json['lastModifiedDate'] == null
        ? null
        : DateTime.parse(json['lastModifiedDate'] as String),
    version: json['version'] as int,
  );
}

Map<String, dynamic> _$AuditableToJson(Auditable instance) => <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$AuditableLombok {
  /// Field
  String createdBy;
  DateTime createdDate;
  String lastModifiedBy;
  DateTime lastModifiedDate;
  int version;

  /// Setter

  void setCreatedBy(String createdBy) {
    this.createdBy = createdBy;
  }

  void setCreatedDate(DateTime createdDate) {
    this.createdDate = createdDate;
  }

  void setLastModifiedBy(String lastModifiedBy) {
    this.lastModifiedBy = lastModifiedBy;
  }

  void setLastModifiedDate(DateTime lastModifiedDate) {
    this.lastModifiedDate = lastModifiedDate;
  }

  void setVersion(int version) {
    this.version = version;
  }

  /// Getter
  String getCreatedBy() {
    return createdBy;
  }

  DateTime getCreatedDate() {
    return createdDate;
  }

  String getLastModifiedBy() {
    return lastModifiedBy;
  }

  DateTime getLastModifiedDate() {
    return lastModifiedDate;
  }

  int getVersion() {
    return version;
  }
}
