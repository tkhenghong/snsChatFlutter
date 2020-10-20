// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multimedia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Multimedia _$MultimediaFromJson(Map<String, dynamic> json) {
  return Multimedia(
    id: json['id'] as String,
    multimediaType:
        _$enumDecodeNullable(_$MultimediaTypeEnumMap, json['multimediaType']),
  )
    ..createdBy = json['createdBy'] as String
    ..createdDate = json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String)
    ..lastModifiedBy = json['lastModifiedBy'] as String
    ..lastModifiedDate = json['lastModifiedDate'] == null
        ? null
        : DateTime.parse(json['lastModifiedDate'] as String)
    ..version = json['version'] as int
    ..fileDirectory = json['fileDirectory'] as String
    ..fileSize = json['fileSize'] as int
    ..fileExtension = json['fileExtension'] as String
    ..contentType = json['contentType'] as String
    ..fileName = json['fileName'] as String;
}

Map<String, dynamic> _$MultimediaToJson(Multimedia instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
      'fileDirectory': instance.fileDirectory,
      'fileSize': instance.fileSize,
      'fileExtension': instance.fileExtension,
      'contentType': instance.contentType,
      'fileName': instance.fileName,
      'id': instance.id,
      'multimediaType': _$MultimediaTypeEnumMap[instance.multimediaType],
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

const _$MultimediaTypeEnumMap = {
  MultimediaType.GIF: 'GIF',
  MultimediaType.Image: 'Image',
  MultimediaType.Video: 'Video',
  MultimediaType.Music: 'Music',
  MultimediaType.Recording: 'Recording',
  MultimediaType.Audio: 'Audio',
  MultimediaType.Word: 'Word',
  MultimediaType.Excel: 'Excel',
  MultimediaType.PowerPoint: 'PowerPoint',
  MultimediaType.Document: 'Document',
  MultimediaType.TXT: 'TXT',
};

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MultimediaLombok {
  /// Field
  String id;
  MultimediaType multimediaType;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setMultimediaType(MultimediaType multimediaType) {
    this.multimediaType = multimediaType;
  }

  /// Getter
  String getId() {
    return id;
  }

  MultimediaType getMultimediaType() {
    return multimediaType;
  }
}
