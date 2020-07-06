// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EmailOTPVerificationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailOTPVerificationRequest _$EmailOTPVerificationRequestFromJson(
    Map<String, dynamic> json) {
  return EmailOTPVerificationRequest(
    emailAddress: json['emailAddress'] as String,
    otpNumber: json['otpNumber'] as String,
  );
}

Map<String, dynamic> _$EmailOTPVerificationRequestToJson(
        EmailOTPVerificationRequest instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
      'otpNumber': instance.otpNumber,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$EmailOTPVerificationRequestLombok {
  /// Field
  String emailAddress;
  String otpNumber;

  /// Setter

  void setEmailAddress(String emailAddress) {
    this.emailAddress = emailAddress;
  }

  void setOtpNumber(String otpNumber) {
    this.otpNumber = otpNumber;
  }

  /// Getter
  String getEmailAddress() {
    return emailAddress;
  }

  String getOtpNumber() {
    return otpNumber;
  }
}
