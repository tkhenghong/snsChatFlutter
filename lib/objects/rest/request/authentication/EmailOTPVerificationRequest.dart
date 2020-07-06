import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'EmailOTPVerificationRequest.g.dart';

@data
@JsonSerializable()
class EmailOTPVerificationRequest {
  @JsonKey(name: 'emailAddress')
  String emailAddress;

  @JsonKey(name: 'otpNumber')
  String otpNumber;

  EmailOTPVerificationRequest({this.emailAddress, this.otpNumber});

  factory EmailOTPVerificationRequest.fromJson(Map<String, dynamic> json) => _$EmailOTPVerificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmailOTPVerificationRequestToJson(this);
}
