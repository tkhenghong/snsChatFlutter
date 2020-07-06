import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'EmailAddressAuthenticationRequest.g.dart';

@data
@JsonSerializable()
class EmailAddressAuthenticationRequest {
  @JsonKey(name: 'emailAddress')
  String emailAddress;

  EmailAddressAuthenticationRequest({this.emailAddress});

  factory EmailAddressAuthenticationRequest.fromJson(Map<String, dynamic> json) => _$EmailAddressAuthenticationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmailAddressAuthenticationRequestToJson(this);
}
