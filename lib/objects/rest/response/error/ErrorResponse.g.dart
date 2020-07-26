// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ErrorResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) {
  return ErrorResponse(
    exceptionName: json['exceptionName'] as String,
    path: json['path'] as String,
    message: json['message'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    trace: json['trace'] as String,
  );
}

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'exceptionName': instance.exceptionName,
      'path': instance.path,
      'message': instance.message,
      'timestamp': instance.timestamp?.toIso8601String(),
      'trace': instance.trace,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$ErrorResponseLombok {
  /// Field
  String exceptionName;
  String path;
  String message;
  DateTime timestamp;
  String trace;

  /// Setter

  void setExceptionName(String exceptionName) {
    this.exceptionName = exceptionName;
  }

  void setPath(String path) {
    this.path = path;
  }

  void setMessage(String message) {
    this.message = message;
  }

  void setTimestamp(DateTime timestamp) {
    this.timestamp = timestamp;
  }

  void setTrace(String trace) {
    this.trace = trace;
  }

  /// Getter
  String getExceptionName() {
    return exceptionName;
  }

  String getPath() {
    return path;
  }

  String getMessage() {
    return message;
  }

  DateTime getTimestamp() {
    return timestamp;
  }

  String getTrace() {
    return trace;
  }
}
