// Combinations. If the multimedia object contains
// conversationId only: Conversation Group's photo
// userContactId only: User Contact's Photo
// conversationId + messageId = A Multimedia message, belonged to a conversation
// userId = User's multimedia photo;

class Multimedia {
  // Image, Video, Gifs, Sticker, Recording, links
  String id;
  String localFullFileUrl;
  String localThumbnailUrl;
  String remoteThumbnailUrl;
  String remoteFullFileUrl;
  String messageId; // Belong to a message.
  String userContactId; // Belong to user too. Because 1 User, 1 UserContact.
  String conversationId; // Belong to ConversationGroup group photo
  String userId;
  int size;

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
      this.size});

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
        size = json['size'];

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
        'size': size,
      };

// KS put
// mediaCheckPoint
// mediaPercentage
// But I don't think I really need this, or I need to save this into database
}
