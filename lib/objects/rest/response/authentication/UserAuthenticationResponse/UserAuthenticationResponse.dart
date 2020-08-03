import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'UserAuthenticationResponse.g.dart';

@data
@JsonSerializable()
class UserAuthenticationResponse {
  @JsonKey(name: 'jwt')
  String jwt;

  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'otpExpirationTime')
  DateTime otpExpirationTime;

  UserAuthenticationResponse({this.jwt, this.username, this.otpExpirationTime});

  factory UserAuthenticationResponse.fromJson(Map<String, dynamic> json) => _$UserAuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserAuthenticationResponseToJson(this);
}
