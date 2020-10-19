// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadedFile _$UploadedFileFromJson(Map<String, dynamic> json) {
  return UploadedFile(
    fileDirectory: json['fileDirectory'] as String,
    fileSize: json['fileSize'] as int,
    fileExtension: json['fileExtension'] as String,
    contentType: json['contentType'] as String,
    fileName: json['fileName'] as String,
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

Map<String, dynamic> _$UploadedFileToJson(UploadedFile instance) =>
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
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UploadedFileLombok {
  /// Field
  String fileDirectory;
  int fileSize;
  String fileExtension;
  String contentType;
  String fileName;

  /// Setter

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
