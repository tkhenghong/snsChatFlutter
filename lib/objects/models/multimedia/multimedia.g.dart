// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multimedia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Multimedia _$MultimediaFromJson(Map<String, dynamic> json) {
  return Multimedia(
    id: json['id'] as String,
    localFullFileUrl: json['localFullFileUrl'] as String,
    localThumbnailUrl: json['localThumbnailUrl'] as String,
    remoteThumbnailUrl: json['remoteThumbnailUrl'] as String,
    remoteFullFileUrl: json['remoteFullFileUrl'] as String,
    messageId: json['messageId'] as String,
    userContactId: json['userContactId'] as String,
    conversationId: json['conversationId'] as String,
    userId: json['userId'] as String,
    fileSize: json['fileSize'] as int,
  );
}

Map<String, dynamic> _$MultimediaToJson(Multimedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'localFullFileUrl': instance.localFullFileUrl,
      'localThumbnailUrl': instance.localThumbnailUrl,
      'remoteThumbnailUrl': instance.remoteThumbnailUrl,
      'remoteFullFileUrl': instance.remoteFullFileUrl,
      'messageId': instance.messageId,
      'userContactId': instance.userContactId,
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'fileSize': instance.fileSize,
    };

// **************************************************************************
// DataGenerator
// **************************************************************************

abstract class _$MultimediaLombok {
  /// Field
  String id;
  String localFullFileUrl;
  String localThumbnailUrl;
  String remoteThumbnailUrl;
  String remoteFullFileUrl;
  String messageId;
  String userContactId;
  String conversationId;
  String userId;
  int fileSize;

  /// Setter

  void setId(String id) {
    this.id = id;
  }

  void setLocalFullFileUrl(String localFullFileUrl) {
    this.localFullFileUrl = localFullFileUrl;
  }

  void setLocalThumbnailUrl(String localThumbnailUrl) {
    this.localThumbnailUrl = localThumbnailUrl;
  }

  void setRemoteThumbnailUrl(String remoteThumbnailUrl) {
    this.remoteThumbnailUrl = remoteThumbnailUrl;
  }

  void setRemoteFullFileUrl(String remoteFullFileUrl) {
    this.remoteFullFileUrl = remoteFullFileUrl;
  }

  void setMessageId(String messageId) {
    this.messageId = messageId;
  }

  void setUserContactId(String userContactId) {
    this.userContactId = userContactId;
  }

  void setConversationId(String conversationId) {
    this.conversationId = conversationId;
  }

  void setUserId(String userId) {
    this.userId = userId;
  }

  void setFileSize(int fileSize) {
    this.fileSize = fileSize;
  }

  /// Getter
  String getId() {
    return id;
  }

  String getLocalFullFileUrl() {
    return localFullFileUrl;
  }

  String getLocalThumbnailUrl() {
    return localThumbnailUrl;
  }

  String getRemoteThumbnailUrl() {
    return remoteThumbnailUrl;
  }

  String getRemoteFullFileUrl() {
    return remoteFullFileUrl;
  }

  String getMessageId() {
    return messageId;
  }

  String getUserContactId() {
    return userContactId;
  }

  String getConversationId() {
    return conversationId;
  }

  String getUserId() {
    return userId;
  }

  int getFileSize() {
    return fileSize;
  }
}
