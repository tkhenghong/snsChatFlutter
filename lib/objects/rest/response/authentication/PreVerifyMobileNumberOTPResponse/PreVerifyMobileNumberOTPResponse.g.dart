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
    mobileNumber: json['mobileNumber'] as String,
    emailAddress: json['emailAddress'] as String,
  );
}

Map<String, dynamic> _$PreVerifyMobileNumberOTPResponseToJson(
        PreVerifyMobileNumberOTPResponse instance) =>
    <String, dynamic>{
      'tokenExpiryTime': instance.tokenExpiryTime?.toIso8601String(),
      'mobileNumber': instance.mobileNumber,
      'emailAddress': instance.emailAddress,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$PreVerifyMobileNumberOTPResponseLombok {
  /// Field
  DateTime tokenExpiryTime;
  String mobileNumber;
  String emailAddress;

  /// Setter

  void setTokenExpiryTime(DateTime tokenExpiryTime) {
    this.tokenExpiryTime = tokenExpiryTime;
  }

  void setMobileNumber(String mobileNumber) {
    this.mobileNumber = mobileNumber;
  }

  void setEmailAddress(String emailAddress) {
    this.emailAddress = emailAddress;
  }

  /// Getter
  DateTime getTokenExpiryTime() {
    return tokenExpiryTime;
  }

  String getMobileNumber() {
    return mobileNumber;
  }

  String getEmailAddress() {
    return emailAddress;
  }
}
