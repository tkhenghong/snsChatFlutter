// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PreVerifyMobileNumberOTPResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreVerifyMobileNumberOTPResponse _$PreVerifyMobileNumberOTPResponseFromJson(
    Map<String, dynamic> json) {
  return PreVerifyMobileNumberOTPResponse(
    tokenExpiryTime: json['tokenExpiryTime'] == null
        ? null
        : DateTime.parse(json['tokenExpiryTime'] as String),
    maskedMobileNumber: json['maskedMobileNumber'] as String,
    maskedEmailAddress: json['maskedEmailAddress'] as String,
    secureKeyword: json['secureKeyword'] as String,
  );
}

Map<String, dynamic> _$PreVerifyMobileNumberOTPResponseToJson(
        PreVerifyMobileNumberOTPResponse instance) =>
    <String, dynamic>{
      'tokenExpiryTime': instance.tokenExpiryTime?.toIso8601String(),
      'maskedMobileNumber': instance.maskedMobileNumber,
      'maskedEmailAddress': instance.maskedEmailAddress,
      'secureKeyword': instance.secureKeyword,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$PreVerifyMobileNumberOTPResponseLombok {
  /// Field
  DateTime tokenExpiryTime;
  String maskedMobileNumber;
  String maskedEmailAddress;
  String secureKeyword;

  /// Setter

  void setTokenExpiryTime(DateTime tokenExpiryTime) {
    this.tokenExpiryTime = tokenExpiryTime;
  }

  void setMaskedMobileNumber(String maskedMobileNumber) {
    this.maskedMobileNumber = maskedMobileNumber;
  }

  void setMaskedEmailAddress(String maskedEmailAddress) {
    this.maskedEmailAddress = maskedEmailAddress;
  }

  void setSecureKeyword(String secureKeyword) {
    this.secureKeyword = secureKeyword;
  }

  /// Getter
  DateTime getTokenExpiryTime() {
    return tokenExpiryTime;
  }

  String getMaskedMobileNumber() {
    return maskedMobileNumber;
  }

  String getMaskedEmailAddress() {
    return maskedEmailAddress;
  }

  String getSecureKeyword() {
    return secureKeyword;
  }
}
