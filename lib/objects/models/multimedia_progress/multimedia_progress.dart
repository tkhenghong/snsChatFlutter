//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'multimedia_progress.g.dart';

@data
@JsonSerializable()
class MultimediaProgress {
  @JsonKey(name: 'multimediaId')
  String multimediaId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'remoteUrl')
  String remoteUrl;

  @JsonKey(name: 'taskId')
  String taskId;

  @JsonKey(name: 'progress')
  int progress = 0;

//  @JsonKey(name: 'status')
//  String status = DownloadTaskStatus.undefined.toString();

  MultimediaProgress({this.multimediaId, this.name, this.remoteUrl, this.taskId, this.progress});

  factory MultimediaProgress.fromJson(Map<String, dynamic> json) => _$MultimediaProgressFromJson(json);

  Map<String, dynamic> toJson() => _$MultimediaProgressToJson(this);
}
