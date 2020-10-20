import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'unmute_conversation_group_notification_request.g.dart';

@data
@JsonSerializable()
class UnmuteConversationGroupNotificationRequest {
  @JsonKey(name: 'conversationGroupMuteNotificationId')
  String conversationGroupMuteNotificationId;

  UnmuteConversationGroupNotificationRequest({this.conversationGroupMuteNotificationId});

  factory UnmuteConversationGroupNotificationRequest.fromJson(Map<String, dynamic> json) => _$UnmuteConversationGroupNotificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UnmuteConversationGroupNotificationRequestToJson(this);
}
