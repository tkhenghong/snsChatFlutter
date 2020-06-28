import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:lombok/lombok.dart';

@data
class MultimediaProgress {
  final String multimediaId;
  final String name;
  final String remoteUrl;
  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  MultimediaProgress({this.multimediaId, this.name, this.remoteUrl, this.taskId, this.progress, this.status});

  MultimediaProgress.fromJson(Map<String, dynamic> json)
      : multimediaId = json['multimediaId'],
        remoteUrl = json['remoteUrl'],
        name = json['name'],
        taskId = json['taskId'],
        progress = json['progress'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'multimediaId': multimediaId,
        'remoteUrl': remoteUrl,
        'name': name,
        'taskId': taskId,
        'progress': progress,
        'status': status,
      };
}
