import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'mute_conversation_group_notification_request.g.dart';

@data
@JsonSerializable()
class MuteConversationGroupNotificationRequest {
  @JsonKey(name: 'blockNotificationExpireTime')
  DateTime blockNotificationExpireTime;

  MuteConversationGroupNotificationRequest({this.blockNotificationExpireTime});

  factory MuteConversationGroupNotificationRequest.fromJson(Map<String, dynamic> json) => _$MuteConversationGroupNotificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MuteConversationGroupNotificationRequestToJson(this);
}
