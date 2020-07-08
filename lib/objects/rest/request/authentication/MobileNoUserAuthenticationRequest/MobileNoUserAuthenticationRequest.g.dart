// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MobileNoUserAuthenticationRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileNoUserAuthenticationRequest _$MobileNoUserAuthenticationRequestFromJson(
    Map<String, dynamic> json) {
  return MobileNoUserAuthenticationRequest(
    mobileNo: json['mobileNo'] as String,
  );
}

Map<String, dynamic> _$MobileNoUserAuthenticationRequestToJson(
        MobileNoUserAuthenticationRequest instance) =>
    <String, dynamic>{
      'mobileNo': instance.mobileNo,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MobileNoUserAuthenticationRequestLombok {
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
