import 'dart:io';
import 'dart:typed_data';

import 'package:snschat_flutter/general/functions/repeating_functions.dart';

class Multimedia {
  // Image, Video, Gifs, Sticker, Recording, links
  String id;
  String localFullFileUrl;
  String localThumbnailUrl;
  String remoteThumbnailUrl;
  String remoteFullFileUrl;
  String imageDataId; // Uint8List
  String imageFileId; // File

  Multimedia(
      {this.id,
      this.localFullFileUrl,
      this.localThumbnailUrl,
      this.remoteThumbnailUrl,
      this.remoteFullFileUrl,
      this.imageDataId,
      this.imageFileId});

  Multimedia.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        localFullFileUrl = json['localFullFileUrl'],
        localThumbnailUrl = json['localThumbnailUrl'],
        remoteThumbnailUrl = json['remoteThumbnailUrl'],
        remoteFullFileUrl = json['remoteFullFileUrl'],
        imageDataId = json['imageDataId'],
        imageFileId = json['imageFileId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'localFullFileUrl': localFullFileUrl,
        'localThumbnailUrl': localThumbnailUrl,
        'remoteThumbnailUrl': remoteThumbnailUrl,
        'remoteFullFileUrl': remoteFullFileUrl,
        'imageDataId': imageDataId,
        'imageFileId': imageFileId,
      };

// KS put
// mediaCheckPoint
// mediaPercentage
// But I don't think I really need this, or I need to save this into database
}
