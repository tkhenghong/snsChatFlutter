
import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'VerifyEmailAddressResponse.g.dart';

@data
@JsonSerializable()
class VerifyEmailAddressResponse {
  @JsonKey(name: 'jwt')
  String jwt;

  VerifyEmailAddressResponse({this.jwt});

  factory VerifyEmailAddressResponse.fromJson(Map<String, dynamic> json) => _$VerifyEmailAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailAddressResponseToJson(this);
}
