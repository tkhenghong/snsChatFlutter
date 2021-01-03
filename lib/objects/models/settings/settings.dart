import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'settings.g.dart';

@data
@JsonSerializable()
class Settings extends Auditable {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'allowNotifications')
  bool allowNotifications;

  Settings({this.id, this.userId, this.allowNotifications});

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
