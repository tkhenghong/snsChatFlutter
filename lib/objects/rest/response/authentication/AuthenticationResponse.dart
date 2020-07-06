import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'AuthenticationResponse.g.dart';

@data
@JsonSerializable()
class AuthenticationResponse {
  @JsonKey(name: 'jwt')
  String jwt;

  AuthenticationResponse({this.jwt});

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) => _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}
