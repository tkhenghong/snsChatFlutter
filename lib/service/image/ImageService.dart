import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:image/image.dart' as CustomImage;

class ImageService {
  FileService fileService = FileService();

  // Returns ImageProvider object
  // Image local thumbnail -> Image local full file -> Image remote thumbnail -> Image remote full file
  // Full file is not as important as thumbnail. (Thumbnails directories MUST be there)
  ImageProvider processImage(Multimedia multimedia, String type) {
    try {
      print("multimedia.localThumbnailUrl: " + multimedia.localThumbnailUrl.toString());
      File file = File(multimedia.localThumbnailUrl); // Image.file(file).image;
      return FileImage(file);
    } catch (e) {
      print("Thumbnail file is missing");
      print("Reason: " + e.toString());
      try {
        print("multimedia.remoteFullFileUrl: " + multimedia.remoteThumbnailUrl.toString());
        return NetworkImage(multimedia.remoteThumbnailUrl); // Image.network(multimedia.remoteFullFileUrl).image
      } catch (e) {
        print("Network file is missing too.");
        print("Reason: " + e.toString());
        // In case network is empty too
        return AssetImage(fileService.getDefaultImagePath(type)); // Image.asset(fileService.getDefaultImagePath(type)).image
      }
    }
  }

  // TODO: Put this into somewhere
  Future<File> getImageThumbnail(File imageFile) async {
    print("getImageThumbnail()");
    try {
      CustomImage.Image image = CustomImage.decodeImage(imageFile.readAsBytesSync());
      CustomImage.Image thumbnail = CustomImage.copyResize(image, width: 50);

      File temporaryThumbnailFile = new File(await fileService.getApplicationDocumentDirectory() + "temp.png")
        ..writeAsBytesSync(CustomImage.encodePng(thumbnail));
      File copiedThumbnailImage = await fileService.copyFile(temporaryThumbnailFile, "ApplicationDocumentDirectory");
      print("copiedThumbnailImage.path: " + copiedThumbnailImage.path);
      return copiedThumbnailImage;
    } catch (e) {
      print("Failed to get thumbnail.");
      print("Reason: " + e.toString());
      return null;
    }
  }
}