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
    emailAddress: json['emailAddress'] as String,
    countryCode: json['countryCode'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'realName': instance.realName,
      'googleAccountId': instance.googleAccountId,
      'emailAddress': instance.emailAddress,
      'countryCode': instance.countryCode,
      'mobileNo': instance.mobileNo,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UserLombok {
  /// Field
  String id;
  String displayName;
  String realName;
  String googleAccountId;
  String emailAddress;
  String countryCode;
  String mobileNo;

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

  void setGoogleAccountId(String googleAccountId) {
    this.googleAccountId = googleAccountId;
  }

  void setEmailAddress(String emailAddress) {
    this.emailAddress = emailAddress;
  }

  void setCountryCode(String countryCode) {
    this.countryCode = countryCode;
  }

  void setMobileNo(String mobileNo) {
    this.mobileNo = mobileNo;
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

  String getGoogleAccountId() {
    return googleAccountId;
  }

  String getEmailAddress() {
    return emailAddress;
  }

  String getCountryCode() {
    return countryCode;
  }

  String getMobileNo() {
    return mobileNo;
  }
}
