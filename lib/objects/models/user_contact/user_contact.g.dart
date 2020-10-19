// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserContact _$UserContactFromJson(Map<String, dynamic> json) {
  return UserContact(
    id: json['id'] as String,
    displayName: json['displayName'] as String,
    realName: json['realName'] as String,
    about: json['about'] as String,
    userIds: (json['userIds'] as List)?.map((e) => e as String)?.toList(),
    userId: json['userId'] as String,
    mobileNo: json['mobileNo'] as String,
    countryCode: json['countryCode'] as String,
    block: json['block'] as bool,
    profilePicture: json['profilePicture'] as String,
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

Map<String, dynamic> _$UserContactToJson(UserContact instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'version': instance.version,
      'id': instance.id,
      'displayName': instance.displayName,
      'realName': instance.realName,
      'about': instance.about,
      'userIds': instance.userIds,
      'userId': instance.userId,
      'mobileNo': instance.mobileNo,
      'countryCode': instance.countryCode,
      'block': instance.block,
      'profilePicture': instance.profilePicture,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$UserContactLombok {
  /// Field
  String id;
  String displayName;
  String realName;
  String about;
  List<String> userIds;
  String userId;
  String mobileNo;
  String countryCode;
  bool block;
  String profilePicture;

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

  void setAbout(String about) {
    this.about = about;
  }

  void setUserIds(List<String> userIds) {
    this.userIds = userIds;
  }

  void setUserId(String userId) {
    this.userId = userId;
  }

  void setMobileNo(String mobileNo) {
    this.mobileNo = mobileNo;
  }

  void setCountryCode(String countryCode) {
    this.countryCode = countryCode;
  }

  void setBlock(bool block) {
    this.block = block;
  }

  void setProfilePicture(String profilePicture) {
    this.profilePicture = profilePicture;
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

  String getAbout() {
    return about;
  }

  List<String> getUserIds() {
    return userIds;
  }

  String getUserId() {
    return userId;
  }

  String getMobileNo() {
    return mobileNo;
  }

  String getCountryCode() {
    return countryCode;
  }

  bool getBlock() {
    return block;
  }

  String getProfilePicture() {
    return profilePicture;
  }
}
