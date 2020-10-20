import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'add_conversation_group_admin_request.g.dart';

@data
@JsonSerializable()
class AddConversationGroupAdminRequest {
  @JsonKey(name: 'groupMemberIds')
  List<String> groupMemberIds;

  AddConversationGroupAdminRequest({this.groupMemberIds});

  factory AddConversationGroupAdminRequest.fromJson(Map<String, dynamic> json) => _$AddConversationGroupAdminRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddConversationGroupAdminRequestToJson(this);
}
