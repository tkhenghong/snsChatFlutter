import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/auditable/auditable.dart';

part 'uploaded_file.g.dart';

@data
@JsonSerializable()
class UploadedFile extends Auditable {
  @JsonKey(name: 'fileDirectory')
  String fileDirectory;

  @JsonKey(name: 'fileSize')
  int fileSize;

  @JsonKey(name: 'fileExtension')
  String fileExtension;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: 'fileName')
  String fileName;

  UploadedFile({this.fileDirectory, this.fileSize, this.fileExtension, this.contentType, this.fileName});

  factory UploadedFile.fromJson(Map<String, dynamic> json) => _$UploadedFileFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedFileToJson(this);
}
