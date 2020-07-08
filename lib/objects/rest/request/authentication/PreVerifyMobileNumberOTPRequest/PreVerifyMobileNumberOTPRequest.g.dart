// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PreVerifyMobileNumberOTPRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreVerifyMobileNumberOTPRequest _$PreVerifyMobileNumberOTPRequestFromJson(
    Map<String, dynamic> json) {
  return PreVerifyMobileNumberOTPRequest(
    mobileNumber: json['mobileNumber'] as String,
  );
}

Map<String, dynamic> _$PreVerifyMobileNumberOTPRequestToJson(
        PreVerifyMobileNumberOTPRequest instance) =>
    <String, dynamic>{
      'mobileNumber': instance.mobileNumber,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$PreVerifyMobileNumberOTPRequestLombok {
  /// Field
  String mobileNumber;

  /// Setter

  void setMobileNumber(String mobileNumber) {
    this.mobileNumber = mobileNumber;
  }

  /// Getter
  String getMobileNumber() {
    return mobileNumber;
  }
}
