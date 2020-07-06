import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'user_contact.g.dart';

@data
@JsonSerializable()
class UserContact {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'displayName')
  String displayName;

  @JsonKey(name: 'realName')
  String realName;

  @JsonKey(name: 'about')
  String about;

  @JsonKey(name: 'userIds')
  List<String> userIds;

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'mobileNo')
  String mobileNo;

  @JsonKey(name: 'lastSeenDate')
  DateTime lastSeenDate;

  @JsonKey(name: 'block')
  bool block;

  @JsonKey(name: 'multimediaId')
  String multimediaId;

  UserContact({this.id, this.displayName, this.realName, this.about, this.userIds, this.userId, this.mobileNo, this.lastSeenDate, this.block, this.multimediaId});

  factory UserContact.fromJson(Map<String, dynamic> json) => _$UserContactFromJson(json);

  Map<String, dynamic> toJson() => _$UserContactToJson(this);
}
