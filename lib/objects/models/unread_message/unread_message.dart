import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/auditable/auditable.dart';

part 'unread_message.g.dart';

@data
@JsonSerializable()
class UnreadMessage extends Auditable {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'conversationId')
  String conversationId;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'lastMessage')
  String lastMessage;

  @JsonKey(name: 'count')
  int count;

  UnreadMessage({this.id, this.userId, this.conversationId, this.lastMessage, this.count});

  factory UnreadMessage.fromJson(Map<String, dynamic> json) => _$UnreadMessageFromJson(json);

  Map<String, dynamic> toJson() => _$UnreadMessageToJson(this);
}
