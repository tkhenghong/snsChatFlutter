import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'PreVerifyMobileNumberOTPRequest.g.dart';

@data
@JsonSerializable()
class PreVerifyMobileNumberOTPRequest {
  @JsonKey(name: 'mobileNumber')
  String mobileNumber;

  PreVerifyMobileNumberOTPRequest({this.mobileNumber});

  factory PreVerifyMobileNumberOTPRequest.fromJson(Map<String, dynamic> json) => _$PreVerifyMobileNumberOTPRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PreVerifyMobileNumberOTPRequestToJson(this);
}
