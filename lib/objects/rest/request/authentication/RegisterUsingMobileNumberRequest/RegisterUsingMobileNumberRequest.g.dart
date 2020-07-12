// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegisterUsingMobileNumberRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUsingMobileNumberRequest _$RegisterUsingMobileNumberRequestFromJson(
    Map<String, dynamic> json) {
  return RegisterUsingMobileNumberRequest(
    mobileNo: json['mobileNo'] as String,
    countryCode: json['countryCode'] as String,
  );
}

Map<String, dynamic> _$RegisterUsingMobileNumberRequestToJson(
        RegisterUsingMobileNumberRequest instance) =>
    <String, dynamic>{
      'mobileNo': instance.mobileNo,
      'countryCode': instance.countryCode,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$RegisterUsingMobileNumberRequestLombok {
  /// Field
  String mobileNo;
  String countryCode;

  /// Setter

  void setMobileNo(String mobileNo) {
    this.mobileNo = mobileNo;
  }

  void setCountryCode(String countryCode) {
    this.countryCode = countryCode;
  }

  /// Getter
  String getMobileNo() {
    return mobileNo;
  }

  String getCountryCode() {
    return countryCode;
  }
}
