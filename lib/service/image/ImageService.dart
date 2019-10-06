import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:image/image.dart' as CustomImage;

class ImageService {
  FileService fileService = FileService();

  // Returns ImageProvider object
  // Image local thumbnail -> Image remote thumbnail -> Image remote full file
  // Remember, ONLY load full file when view it in whole screen.
  // Full file is not as important as thumbnail. (Thumbnails directories MUST be there)
  // Network file can gone, but thumbnails are always secured in local storage
  // (In local storage, you're unable to delete it manually, plus,
  // network storage always have a thumbnail copy of it, full file is removable(except UserContact photo))
  ImageProvider processImageThumbnail(Multimedia multimedia, String type) {
    if (isObjectEmpty(multimedia) || isStringEmpty(type)) {
      return AssetImage(fileService.getDefaultImagePath(type));
    }
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

  Future<File> getImageThumbnail(File imageFile) async {
    print("getImageThumbnail()");
    try {
      // Convert to Image plugin format
      CustomImage.Image image = CustomImage.decodeImage(imageFile.readAsBytesSync());
      // Create thumbnail
      CustomImage.Image thumbnail = CustomImage.copyResize(image, width: 50);

      String fullThumbnailDirectory = await fileService.getApplicationDocumentDirectory() +
          "/" +
          "thumbnail-" +
          new DateTime.now().millisecondsSinceEpoch.toString() +
          ".png";
      // Put it into our directory, set it as temp.png first (File format: FILEPATH/thumbnail-95102006192014.png)
      File thumbnailFile = new File(fullThumbnailDirectory)..writeAsBytesSync(CustomImage.encodePng(thumbnail));

      return thumbnailFile;
    } catch (e) {
      print("Failed to get thumbnail.");
      print("Reason: " + e.toString());
      return null;
    }
  }
}
