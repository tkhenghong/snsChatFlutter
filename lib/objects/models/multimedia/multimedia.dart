import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'multimedia.g.dart';

// Image, Video, GIFs, Sticker, Recording, links
@data
@JsonSerializable()
class Multimedia extends UploadedFile {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'multimediaType')
  MultimediaType multimediaType;

  Multimedia({this.id, this.multimediaType});

  factory Multimedia.fromJson(Map<String, dynamic> json) => _$MultimediaFromJson(json);

  Map<String, dynamic> toJson() => _$MultimediaToJson(this);
}
