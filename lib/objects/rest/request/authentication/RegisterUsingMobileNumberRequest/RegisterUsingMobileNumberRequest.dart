
import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'RegisterUsingMobileNumberRequest.g.dart';

@data
@JsonSerializable()
class RegisterUsingMobileNumberRequest {
  @JsonKey(name: 'mobileNo')
  String mobileNo;

  @JsonKey(name: 'countryCode')
  String countryCode;

  RegisterUsingMobileNumberRequest({this.mobileNo, this.countryCode});

  factory RegisterUsingMobileNumberRequest.fromJson(Map<String, dynamic> json) => _$RegisterUsingMobileNumberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUsingMobileNumberRequestToJson(this);
}
