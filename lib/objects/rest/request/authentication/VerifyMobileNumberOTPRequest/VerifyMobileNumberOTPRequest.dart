import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'VerifyMobileNumberOTPRequest.g.dart';

@data
@JsonSerializable()
class VerifyMobileNumberOTPRequest {
  @JsonKey(name: 'mobileNo')
  String mobileNo;

  @JsonKey(name: 'otpNumber')
  String otpNumber;

  @JsonKey(name: 'secureKeyword')
  String secureKeyword;

  VerifyMobileNumberOTPRequest({this.mobileNo, this.otpNumber, this.secureKeyword});

  factory VerifyMobileNumberOTPRequest.fromJson(Map<String, dynamic> json) => _$VerifyMobileNumberOTPRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyMobileNumberOTPRequestToJson(this);
}
