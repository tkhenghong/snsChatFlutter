import 'package:json_annotation/json_annotation.dart';
import 'package:lombok/lombok.dart';

part 'multimedia.g.dart';

// Image, Video, GIFs, Sticker, Recording, links
@data
@JsonSerializable()
class Multimedia {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'localFullFileUrl')
  String localFullFileUrl;

  @JsonKey(name: 'localThumbnailUrl')
  String localThumbnailUrl;

  @JsonKey(name: 'remoteThumbnailUrl')
  String remoteThumbnailUrl;

  @JsonKey(name: 'remoteFullFileUrl')
  String remoteFullFileUrl;

  @JsonKey(name: 'messageId')
  String messageId; // Belong to a message.

  @JsonKey(name: 'userContactId')
  String userContactId; // Belong to user too. Because 1 User, 1 UserContact.

  @JsonKey(name: 'conversationId')
  String conversationId; // Belong to ConversationGroup group photo

  @JsonKey(name: 'userId')
  String userId;

  @JsonKey(name: 'fileSize')
  int fileSize;

  Multimedia({this.id, this.localFullFileUrl, this.localThumbnailUrl, this.remoteThumbnailUrl, this.remoteFullFileUrl, this.messageId, this.userContactId, this.conversationId, this.userId, this.fileSize});

  factory Multimedia.fromJson(Map<String, dynamic> json) => _$MultimediaFromJson(json);

  Map<String, dynamic> toJson() => _$MultimediaToJson(this);
}

/* Combinations:
 conversationId only: Conversation Group's photo
 userContactId only: User Contact's Photo
 conversationId + messageId = A Multimedia message, belonged to a conversation
 userId = User's multimedia photo;
*/
