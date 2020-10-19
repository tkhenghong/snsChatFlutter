import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'conversation_group_mute_notification.g.dart';

@data
@JsonSerializable()
class ConversationGroupMuteNotification {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'userContactId')
  String userContactId;

  @JsonKey(name: 'conversationGroupId')
  String conversationGroupId;

  @JsonKey(name: 'notificationBlockExpire')
  DateTime notificationBlockExpire;

  ConversationGroupMuteNotification({this.id, this.userContactId, this.conversationGroupId, this.notificationBlockExpire});

  factory ConversationGroupMuteNotification.fromJson(Map<String, dynamic> json) => _$ConversationGroupMuteNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationGroupMuteNotificationToJson(this);
}
