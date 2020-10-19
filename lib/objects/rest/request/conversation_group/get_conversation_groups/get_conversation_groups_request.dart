import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'get_conversation_groups_request.g.dart';

@data
@JsonSerializable()
class GetConversationGroupsRequest {
  @JsonKey(name: 'conversationGroupName')
  String conversationGroupName;

  @JsonKey(name: 'pageable')
  Pageable pageable;

  GetConversationGroupsRequest({this.conversationGroupName, this.pageable});

  factory GetConversationGroupsRequest.fromJson(Map<String, dynamic> json) => _$GetConversationGroupsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetConversationGroupsRequestToJson(this);
}