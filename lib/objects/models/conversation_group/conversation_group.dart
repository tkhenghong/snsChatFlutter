import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/enums/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'conversation_group.g.dart';

// https://www.thedroidsonroids.com/blog/how-to-build-an-app-with-flutter-networking-and-connecting-to-api
@data
@JsonSerializable()
class ConversationGroup extends Auditable {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'creatorUserId')
  String creatorUserId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'conversationGroupType')
  ConversationGroupType conversationGroupType;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'memberIds')
  List<String> memberIds; // UserContactIds

  @JsonKey(name: 'adminMemberIds')
  List<String> adminMemberIds;

  @JsonKey(name: 'groupPhoto')
  String groupPhoto;

  ConversationGroup({this.id, this.conversationGroupType, this.creatorUserId, this.name, this.description, this.memberIds, this.adminMemberIds, this.groupPhoto});

  factory ConversationGroup.fromJson(Map<String, dynamic> json) => _$ConversationGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationGroupToJson(this);
}
