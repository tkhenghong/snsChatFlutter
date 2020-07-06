// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    displayName: json['displayName'] as String,
    realName: json['realName'] as String,
    mobileNo: json['mobileNo'] as String,
    googleAccountId: json['googleAccountId'] as String,
    countryCode: json['countryCode'] as String,
    effectivePhoneNumber: json['effectivePhoneNumber'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'realName': instance.realName,
      'mobileNo': instance.mobileNo,
      'googleAccountId': instance.googleAccountId,
      'countryCode': instance.countryCode,
      'effectivePhoneNumber': instance.effectivePhoneNumber,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UserLombok {
  /// Field
  String id;
  String displayName;
  String realName;
  String mobileNo;
  String googleAccountId;
  String countryCode;
  String effectivePhoneNumber;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setDisplayName(String displayName) {
    this.displayName = displayName;
  }

  void setRealName(String realName) {
    this.realName = realName;
  }

  void setMobileNo(String mobileNo) {
    this.mobileNo = mobileNo;
  }

  void setGoogleAccountId(String googleAccountId) {
    this.googleAccountId = googleAccountId;
  }

  void setCountryCode(String countryCode) {
    this.countryCode = countryCode;
  }

  void setEffectivePhoneNumber(String effectivePhoneNumber) {
    this.effectivePhoneNumber = effectivePhoneNumber;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getDisplayName() {
    return displayName;
  }

  String getRealName() {
    return realName;
  }

  String getMobileNo() {
    return mobileNo;
  }

  String getGoogleAccountId() {
    return googleAccountId;
  }

  String getCountryCode() {
    return countryCode;
  }

  String getEffectivePhoneNumber() {
    return effectivePhoneNumber;
  }
}
