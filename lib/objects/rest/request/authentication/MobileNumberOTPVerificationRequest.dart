
import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'MobileNumberOTPVerificationRequest.g.dart';

@data
@JsonSerializable()
class MobileNumberOTPVerificationRequest {
  @JsonKey(name: 'mobileNo')
  String mobileNo;

  @JsonKey(name: 'otpNumber')
  String otpNumber;

  MobileNumberOTPVerificationRequest({this.mobileNo, this.otpNumber});

  factory MobileNumberOTPVerificationRequest.fromJson(Map<String, dynamic> json) => _$MobileNumberOTPVerificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MobileNumberOTPVerificationRequestToJson(this);
}
