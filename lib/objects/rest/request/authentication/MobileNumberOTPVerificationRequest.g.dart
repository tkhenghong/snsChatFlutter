// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MobileNumberOTPVerificationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileNumberOTPVerificationRequest _$MobileNumberOTPVerificationRequestFromJson(
    Map<String, dynamic> json) {
  return MobileNumberOTPVerificationRequest(
    mobileNo: json['mobileNo'] as String,
    otpNumber: json['otpNumber'] as String,
  );
}

Map<String, dynamic> _$MobileNumberOTPVerificationRequestToJson(
        MobileNumberOTPVerificationRequest instance) =>
    <String, dynamic>{
      'mobileNo': instance.mobileNo,
      'otpNumber': instance.otpNumber,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MobileNumberOTPVerificationRequestLombok {
  /// Field
  String mobileNo;
  String otpNumber;

  /// Setter

  void setMobileNo(String mobileNo) {
    this.mobileNo = mobileNo;
  }

  void setOtpNumber(String otpNumber) {
    this.otpNumber = otpNumber;
  }

  /// Getter
  String getMobileNo() {
    return mobileNo;
  }

  String getOtpNumber() {
    return otpNumber;
  }
}
