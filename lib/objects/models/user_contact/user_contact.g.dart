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
    lastSeenDate: json['lastSeenDate'] == null
        ? null
        : DateTime.parse(json['lastSeenDate'] as String),
    block: json['block'] as bool,
    multimediaId: json['multimediaId'] as String,
  );
}

Map<String, dynamic> _$UserContactToJson(UserContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'realName': instance.realName,
      'about': instance.about,
      'userIds': instance.userIds,
      'userId': instance.userId,
      'mobileNo': instance.mobileNo,
      'lastSeenDate': instance.lastSeenDate?.toIso8601String(),
      'block': instance.block,
      'multimediaId': instance.multimediaId,
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
  DateTime lastSeenDate;
  bool block;
  String multimediaId;

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

  void setLastSeenDate(DateTime lastSeenDate) {
    this.lastSeenDate = lastSeenDate;
  }

  void setBlock(bool block) {
    this.block = block;
  }

  void setMultimediaId(String multimediaId) {
    this.multimediaId = multimediaId;
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

  DateTime getLastSeenDate() {
    return lastSeenDate;
  }

  bool getBlock() {
    return block;
  }

  String getMultimediaId() {
    return multimediaId;
  }
}
