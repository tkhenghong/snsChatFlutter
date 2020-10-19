// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multimedia_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultimediaResponse _$MultimediaResponseFromJson(Map<String, dynamic> json) {
  return MultimediaResponse(
    id: json['id'] as String,
    multimediaType:
        _$enumDecodeNullable(_$MultimediaTypeEnumMap, json['multimediaType']),
    fileDirectory: json['fileDirectory'] as String,
    fileSize: json['fileSize'] as int,
    fileExtension: json['fileExtension'] as String,
    contentType: json['contentType'] as String,
    fileName: json['fileName'] as String,
  );
}

Map<String, dynamic> _$MultimediaResponseToJson(MultimediaResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'multimediaType': _$MultimediaTypeEnumMap[instance.multimediaType],
      'fileDirectory': instance.fileDirectory,
      'fileSize': instance.fileSize,
      'fileExtension': instance.fileExtension,
      'contentType': instance.contentType,
      'fileName': instance.fileName,
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
  MultimediaType.TXT: 'TXT',
};

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MultimediaResponseLombok {
  /// Field
  String id;
  MultimediaType multimediaType;
  String fileDirectory;
  int fileSize;
  String fileExtension;
  String contentType;
  String fileName;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setMultimediaType(MultimediaType multimediaType) {
    this.multimediaType = multimediaType;
  }

  void setFileDirectory(String fileDirectory) {
    this.fileDirectory = fileDirectory;
  }

  void setFileSize(int fileSize) {
    this.fileSize = fileSize;
  }

  void setFileExtension(String fileExtension) {
    this.fileExtension = fileExtension;
  }

  void setContentType(String contentType) {
    this.contentType = contentType;
  }

  void setFileName(String fileName) {
    this.fileName = fileName;
  }

  /// Getter
  String getId() {
    return id;
  }

  MultimediaType getMultimediaType() {
    return multimediaType;
  }

  String getFileDirectory() {
    return fileDirectory;
  }

  int getFileSize() {
    return fileSize;
  }

  String getFileExtension() {
    return fileExtension;
  }

  String getContentType() {
    return contentType;
  }

  String getFileName() {
    return fileName;
  }
}
