import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';
import 'package:snschat_flutter/objects/models/index.dart';

part 'user.g.dart';

@data
@JsonSerializable()
class User extends Auditable {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'displayName')
  String displayName;

  @JsonKey(name: 'realName')
  String realName;

  @JsonKey(name: 'emailAddress')
  String emailAddress;

  @JsonKey(name: 'countryCode')
  String countryCode;

  @JsonKey(name: 'mobileNo')
  String mobileNo;

  User({this.id, this.displayName, this.realName, this.mobileNo, this.emailAddress, this.countryCode});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
