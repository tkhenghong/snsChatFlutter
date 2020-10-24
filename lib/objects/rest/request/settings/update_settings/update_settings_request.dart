import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'update_settings_request.g.dart';

@data
@JsonSerializable()
class UpdateSettingsRequest {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'allowNotifications')
  String allowNotifications;

  UpdateSettingsRequest({this.id, this.allowNotifications});

  factory UpdateSettingsRequest.fromJson(Map<String, dynamic> json) => _$UpdateSettingsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateSettingsRequestToJson(this);
}
