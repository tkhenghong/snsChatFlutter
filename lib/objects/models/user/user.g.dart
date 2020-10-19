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
    emailAddress: json['emailAddress'] as String,
    countryCode: json['countryCode'] as String,
  )
    ..createdBy = json['createdBy'] as String
    ..createdDate = json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String)
    ..lastModifiedBy = json['lastModifiedBy'] as String
    ..lastModifiedDate = json['lastModifiedDate'] == null
        ? null
        : DateTime.parse(json['lastModifiedDate'] as String)
    ..version = json['version'] as int;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
      'id': instance.id,
      'displayName': instance.displayName,
      'realName': instance.realName,
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
