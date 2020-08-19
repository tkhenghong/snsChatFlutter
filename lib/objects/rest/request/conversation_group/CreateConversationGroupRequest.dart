import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/enums/index.dart';

part 'CreateConversationGroupRequest.g.dart';

@data
@JsonSerializable()
class CreateConversationGroupRequest {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'conversationGroupType')
  ConversationGroupType conversationGroupType;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'memberIds')
  List<String> memberIds;

  @JsonKey(name: 'adminMemberIds')
  List<String> adminMemberIds;

  CreateConversationGroupRequest({this.name, this.conversationGroupType, this.description, this.memberIds, this.adminMemberIds});

  factory CreateConversationGroupRequest.fromJson(Map<String, dynamic> json) => _$CreateConversationGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateConversationGroupRequestToJson(this);
}
