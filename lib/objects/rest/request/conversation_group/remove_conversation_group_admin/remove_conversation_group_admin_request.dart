import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'remove_conversation_group_admin_request.g.dart';

@data
@JsonSerializable()
class RemoveConversationGroupAdminRequest {
  @JsonKey(name: 'groupMemberIds')
  List<String> groupMemberIds;

  RemoveConversationGroupAdminRequest({this.groupMemberIds});

  factory RemoveConversationGroupAdminRequest.fromJson(Map<String, dynamic> json) => _$RemoveConversationGroupAdminRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveConversationGroupAdminRequestToJson(this);
}
