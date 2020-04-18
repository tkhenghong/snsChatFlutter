import 'package:lombok/lombok.dart';

// Image, Video, GIFs, Sticker, Recording, links
@data
class Multimedia {
  String id;
  String localFullFileUrl;
  String localThumbnailUrl;
  String remoteThumbnailUrl;
  String remoteFullFileUrl;
  String messageId; // Belong to a message.
  String userContactId; // Belong to user too. Because 1 User, 1 UserContact.
  String conversationId; // Belong to ConversationGroup group photo
  String userId;
  int fileSize;

  Multimedia(
      {this.id,
        this.localFullFileUrl,
        this.localThumbnailUrl,
        this.remoteThumbnailUrl,
        this.remoteFullFileUrl,
        this.messageId,
        this.userContactId,
        this.conversationId,
        this.userId,
        this.fileSize});

  Multimedia.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        localFullFileUrl = json['localFullFileUrl'],
        localThumbnailUrl = json['localThumbnailUrl'],
        remoteThumbnailUrl = json['remoteThumbnailUrl'],
        remoteFullFileUrl = json['remoteFullFileUrl'],
        messageId = json['messageId'],
        userContactId = json['userContactId'],
        conversationId = json['conversationId'],
        userId = json['userId'],
        fileSize = json['fileSize'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'localFullFileUrl': localFullFileUrl,
    'localThumbnailUrl': localThumbnailUrl,
    'remoteThumbnailUrl': remoteThumbnailUrl,
    'remoteFullFileUrl': remoteFullFileUrl,
    'messageId': messageId,
    'userContactId': userContactId,
    'conversationId': conversationId,
    'userId': userId,
    'fileSize': fileSize,
  };
}

/* Combinations:
 conversationId only: Conversation Group's photo
 userContactId only: User Contact's Photo
 conversationId + messageId = A Multimedia message, belonged to a conversation
 userId = User's multimedia photo;
*/
