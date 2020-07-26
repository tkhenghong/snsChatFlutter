// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multimedia_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultimediaProgress _$MultimediaProgressFromJson(Map<String, dynamic> json) {
  return MultimediaProgress(
    multimediaId: json['multimediaId'] as String,
    name: json['name'] as String,
    remoteUrl: json['remoteUrl'] as String,
    taskId: json['taskId'] as String,
    progress: json['progress'] as int,
  );
}

Map<String, dynamic> _$MultimediaProgressToJson(MultimediaProgress instance) =>
    <String, dynamic>{
      'multimediaId': instance.multimediaId,
      'name': instance.name,
      'remoteUrl': instance.remoteUrl,
      'taskId': instance.taskId,
      'progress': instance.progress,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MultimediaProgressLombok {
  /// Field
  String multimediaId;
  String name;
  String remoteUrl;
  String taskId;
  int progress;

  /// Setter

  void setMultimediaId(String multimediaId) {
    this.multimediaId = multimediaId;
  }

  void setName(String name) {
    this.name = name;
  }

  void setRemoteUrl(String remoteUrl) {
    this.remoteUrl = remoteUrl;
  }

  void setTaskId(String taskId) {
    this.taskId = taskId;
  }

  void setProgress(int progress) {
    this.progress = progress;
  }

  /// Getter
  String getMultimediaId() {
    return multimediaId;
  }

  String getName() {
    return name;
  }

  String getRemoteUrl() {
    return remoteUrl;
  }

  String getTaskId() {
    return taskId;
  }

  int getProgress() {
    return progress;
  }
}
