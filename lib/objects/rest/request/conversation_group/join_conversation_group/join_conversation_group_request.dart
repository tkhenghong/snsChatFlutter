import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'join_conversation_group_request.g.dart';

@data
@JsonSerializable()
class JoinConversationGroupRequest {
  @JsonKey(name: 'inviteCode')
  String inviteCode;

  JoinConversationGroupRequest({this.inviteCode});

  factory JoinConversationGroupRequest.fromJson(Map<String, dynamic> json) => _$JoinConversationGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinConversationGroupRequestToJson(this);
}
