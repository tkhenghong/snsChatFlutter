import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/index.dart';

part 'multimedia_response.g.dart';

@data
@JsonSerializable()
class MultimediaResponse {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'multimediaType')
  MultimediaType multimediaType;

  @JsonKey(name: 'fileDirectory')
  String fileDirectory;

  @JsonKey(name: 'fileSize')
  // Size of the file in bytes.
  int fileSize;

  @JsonKey(name: 'fileExtension')
  // Name of the file format. Picked from the full file name.
  String fileExtension;

  @JsonKey(name: 'contentType')
  // Content type from MultipartFile.getContentType.
  String contentType;

  @JsonKey(name: 'fileName')
  // Name of the file from the MultipartFile, typically comes from the frontend.
  String fileName;

  MultimediaResponse({this.id, this.multimediaType, this.fileDirectory, this.fileSize, this.fileExtension, this.contentType, this.fileName});

  factory MultimediaResponse.fromJson(Map<String, dynamic> json) => _$MultimediaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MultimediaResponseToJson(this);
}
