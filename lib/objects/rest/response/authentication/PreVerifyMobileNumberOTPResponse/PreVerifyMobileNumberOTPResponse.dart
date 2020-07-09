import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'PreVerifyMobileNumberOTPResponse.g.dart';

@data
@JsonSerializable()
class PreVerifyMobileNumberOTPResponse {
  @JsonKey(name: 'tokenExpiryTime')
  DateTime tokenExpiryTime;

  @JsonKey(name: 'mobileNumber')
  String mobileNumber;

  @JsonKey(name: 'emailAddress')
  String emailAddress;

  @JsonKey(name: 'secureKeyword')
  String secureKeyword;

  PreVerifyMobileNumberOTPResponse({this.tokenExpiryTime, this.mobileNumber, this.emailAddress, this.secureKeyword});

  factory PreVerifyMobileNumberOTPResponse.fromJson(Map<String, dynamic> json) => _$PreVerifyMobileNumberOTPResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PreVerifyMobileNumberOTPResponseToJson(this);
}
