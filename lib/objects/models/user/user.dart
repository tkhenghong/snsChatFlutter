import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'user.g.dart';

@data
@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'displayName')
  String displayName;

  @JsonKey(name: 'realName')
  String realName;

  @JsonKey(name: 'googleAccountId')
  String googleAccountId;

  @JsonKey(name: 'countryCode')
  String countryCode;

  @JsonKey(name: 'mobileNo')
  String mobileNo;

  User({this.id, this.displayName, this.realName, this.mobileNo, this.googleAccountId, this.countryCode});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
