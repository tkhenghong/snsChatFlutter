// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MobileNoAuthenticationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileNoAuthenticationRequest _$MobileNoAuthenticationRequestFromJson(
    Map<String, dynamic> json) {
  return MobileNoAuthenticationRequest(
    mobileNo: json['mobileNo'] as String,
  );
}

Map<String, dynamic> _$MobileNoAuthenticationRequestToJson(
        MobileNoAuthenticationRequest instance) =>
    <String, dynamic>{
      'mobileNo': instance.mobileNo,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MobileNoAuthenticationRequestLombok {
  /// Field
  String mobileNo;

  /// Setter

  void setMobileNo(String mobileNo) {
    this.mobileNo = mobileNo;
  }

  /// Getter
  String getMobileNo() {
    return mobileNo;
  }
}
