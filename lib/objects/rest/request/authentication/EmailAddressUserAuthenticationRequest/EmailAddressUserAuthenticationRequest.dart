import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'EmailAddressUserAuthenticationRequest.g.dart';

@data
@JsonSerializable()
class EmailAddressUserAuthenticationRequest {
  @JsonKey(name: 'emailAddress')
  String emailAddress;

  EmailAddressUserAuthenticationRequest({this.emailAddress});

  factory EmailAddressUserAuthenticationRequest.fromJson(Map<String, dynamic> json) => _$EmailAddressUserAuthenticationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmailAddressUserAuthenticationRequestToJson(this);
}
