import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'VerifyEmailAddressRequest.g.dart';

@data
@JsonSerializable()
class VerifyEmailAddressRequest {
  @JsonKey(name: 'username')
  String username;

  @JsonKey(name: 'password')
  String password;

  VerifyEmailAddressRequest({this.username, this.password});

  factory VerifyEmailAddressRequest.fromJson(Map<String, dynamic> json) => _$VerifyEmailAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailAddressRequestToJson(this);
}
