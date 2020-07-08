import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'UsernamePasswordUserAuthenticationRequest.g.dart';

@data
@JsonSerializable()
class UsernamePasswordUserAuthenticationRequest {
  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'password')
  String password;

  UsernamePasswordUserAuthenticationRequest({this.username, this.password});

  factory UsernamePasswordUserAuthenticationRequest.fromJson(Map<String, dynamic> json) => _$UsernamePasswordUserAuthenticationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UsernamePasswordUserAuthenticationRequestToJson(this);
}
