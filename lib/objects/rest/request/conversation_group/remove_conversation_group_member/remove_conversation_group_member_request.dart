import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'remove_conversation_group_member_request.g.dart';

@data
@JsonSerializable()
class RemoveConversationGroupMemberRequest {
  @JsonKey(name: 'groupMemberIds')
  List<String> groupMemberIds;

  RemoveConversationGroupMemberRequest({this.groupMemberIds});

  factory RemoveConversationGroupMemberRequest.fromJson(Map<String, dynamic> json) => _$RemoveConversationGroupMemberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveConversationGroupMemberRequestToJson(this);
}
