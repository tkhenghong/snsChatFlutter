import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'conversation_group_invite.g.dart';

@data
@JsonSerializable()
class ConversationGroupInvite {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'conversationGroupId')
  String conversationGroupId;

  @JsonKey(name: 'invitationExpireTime')
  DateTime invitationExpireTime;

  @JsonKey(name: 'secretInvitationKey')
  String secretInvitationKey;

  @JsonKey(name: 'invitesRemaining')
  int invitesRemaining;

  ConversationGroupInvite({this.id, this.conversationGroupId, this.invitationExpireTime, this.secretInvitationKey, this.invitesRemaining});

  factory ConversationGroupInvite.fromJson(Map<String, dynamic> json) => _$ConversationGroupInviteFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationGroupInviteToJson(this);
}
