import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'user_contact.g.dart';

@data
@JsonSerializable()
class UserContact extends Auditable {
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

  @JsonKey(name: 'countryCode')
  String countryCode;

  @JsonKey(name: 'block')
  bool block;

  @JsonKey(name: 'profilePicture')
  String profilePicture;

  UserContact({this.id, this.displayName, this.realName, this.about, this.userIds, this.userId, this.mobileNo, this.countryCode, this.block, this.profilePicture});

  factory UserContact.fromJson(Map<String, dynamic> json) => _$UserContactFromJson(json);

  Map<String, dynamic> toJson() => _$UserContactToJson(this);
}
