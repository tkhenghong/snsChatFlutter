import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'add_conversation_group_member_request.g.dart';

@data
@JsonSerializable()
class AddConversationGroupMemberRequest {
  @JsonKey(name: 'groupMemberIds')
  List<String> groupMemberIds;

  AddConversationGroupMemberRequest({this.groupMemberIds});

  factory AddConversationGroupMemberRequest.fromJson(Map<String, dynamic> json) => _$AddConversationGroupMemberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddConversationGroupMemberRequestToJson(this);
}
