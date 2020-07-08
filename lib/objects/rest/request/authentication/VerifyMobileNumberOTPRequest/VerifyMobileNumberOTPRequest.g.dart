// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VerifyMobileNumberOTPRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyMobileNumberOTPRequest _$VerifyMobileNumberOTPRequestFromJson(
    Map<String, dynamic> json) {
  return VerifyMobileNumberOTPRequest(
    mobileNo: json['mobileNo'] as String,
    otpNumber: json['otpNumber'] as String,
    secureKeyword: json['secureKeyword'] as String,
  );
}

Map<String, dynamic> _$VerifyMobileNumberOTPRequestToJson(
        VerifyMobileNumberOTPRequest instance) =>
    <String, dynamic>{
      'mobileNo': instance.mobileNo,
      'otpNumber': instance.otpNumber,
      'secureKeyword': instance.secureKeyword,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$VerifyMobileNumberOTPRequestLombok {
  /// Field
  String mobileNo;
  String otpNumber;
  String secureKeyword;

  /// Setter

  void setMobileNo(String mobileNo) {
    this.mobileNo = mobileNo;
  }

  void setOtpNumber(String otpNumber) {
    this.otpNumber = otpNumber;
  }

  void setSecureKeyword(String secureKeyword) {
    this.secureKeyword = secureKeyword;
  }

  /// Getter
  String getMobileNo() {
    return mobileNo;
  }

  String getOtpNumber() {
    return otpNumber;
  }

  String getSecureKeyword() {
    return secureKeyword;
  }
}
