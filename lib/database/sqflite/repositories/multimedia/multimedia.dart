import 'dart:io';
import 'dart:typed_data';

//Jaguar ORM
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'multimedia.jorm.dart';

class Multimedia {
  // Image, Video, Gifs, Sticker, Recording, links

  Multimedia(
      {this.id,
      this.localFullFileUrl,
      this.localThumbnailUrl,
      this.remoteThumbnailUrl,
      this.remoteFullFileUrl,
      this.imageDataId,
      this.imageFileId,
      this.messageId,
      this.userContactId,
      this.conversationId});

  Multimedia.make(this.id, this.localFullFileUrl, this.localThumbnailUrl, this.remoteThumbnailUrl, this.remoteFullFileUrl, this.imageDataId,
      this.imageFileId, this.messageId, this.userContactId, this.conversationId);

  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String localFullFileUrl;

  @Column(isNullable: true)
  String localThumbnailUrl;

  @Column(isNullable: true)
  String remoteThumbnailUrl;

  @Column(isNullable: true)
  String remoteFullFileUrl;

  @Column(isNullable: true)
  String imageDataId; // Uint8List object

  @Column(isNullable: true)
  String imageFileId; // File object

  @Column(isNullable: true)
  String messageId; // Message object

  @Column(isNullable: true)
  String userContactId; // UserContact object

  @Column(isNullable: true)
  String conversationId; // Conversation object

// KS put
// mediaCheckPoint
// mediaPercentage
// But I don't think I really need this, or I need to save this into database

}

@GenBean()
class MultimediaBean extends Bean<Multimedia> with _MultimediaBean {
//class MultimediaBean extends Bean<Multimedia> {
  MultimediaBean(Adapter adapter) : super(adapter);

  final String tableName = 'multimedia';
}
