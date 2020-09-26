import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/general/enums/index.dart';

part 'conversation_group.g.dart';

// https://www.thedroidsonroids.com/blog/how-to-build-an-app-with-flutter-networking-and-connecting-to-api
@data
@JsonSerializable()
class ConversationGroup {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'creatorUserId')
  String creatorUserId;

  @JsonKey(name: 'createdDate')
  DateTime createdDate;

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

  @JsonKey(name: 'block')
  bool block;

  @JsonKey(name: 'notificationExpireDate')
  DateTime notificationExpireDate; // 0 = unblocked, > 0 = blocked until specific time

  ConversationGroup({this.id, this.creatorUserId, this.createdDate, this.name, this.conversationGroupType, this.block, this.description, this.memberIds, this.adminMemberIds, this.notificationExpireDate});

  factory ConversationGroup.fromJson(Map<String, dynamic> json) => _$ConversationGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationGroupToJson(this);
}
