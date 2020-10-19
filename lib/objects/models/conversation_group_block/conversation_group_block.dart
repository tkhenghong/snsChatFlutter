import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'conversation_group_block.g.dart';

@data
@JsonSerializable()
class ConversationGroupBlock extends Auditable {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'userContactId')
  String userContactId;

  @JsonKey(name: 'conversationGroupId')
  String conversationGroupId;

  ConversationGroupBlock({this.id, this.userContactId, this.conversationGroupId});

  factory ConversationGroupBlock.fromJson(Map<String, dynamic> json) => _$ConversationGroupBlockFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationGroupBlockToJson(this);
}
