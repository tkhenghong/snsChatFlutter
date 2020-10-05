import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'error_response.g.dart';

@data
@JsonSerializable()
class ErrorResponse {
  @JsonKey(name: 'exceptionName')
  String exceptionName;

  @JsonKey(name: 'path')
  String path;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'timestamp')
  DateTime timestamp;

  @JsonKey(name: 'trace')
  String trace;

  ErrorResponse({this.exceptionName, this.path, this.message, this.timestamp, this.trace});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
