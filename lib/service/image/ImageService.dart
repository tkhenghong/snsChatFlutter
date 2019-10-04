import 'dart:io';

import 'package:flutter/material.dart';
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

      // Put it into our directory, set it as temp.png first
      File temporaryThumbnailFile = new File(await fileService.getApplicationDocumentDirectory() + "temp.png")
        ..writeAsBytesSync(CustomImage.encodePng(thumbnail));

      // (Can move it directly. But for safety sake, I create it in
      // somewhere where it's safe first, then  copy it somewhere else)
      //
      // Copy that file to our proper directory
      File copiedThumbnailImage = await fileService.copyFile(temporaryThumbnailFile, "ApplicationDocumentDirectory");
      print("copiedThumbnailImage.path: " + copiedThumbnailImage.path);
      // Delete that temp image to prevent waste storage. Comment it out to show where the temp file is.
      // Fail doesn't matter. (But rarely happens when you have storage permission already)
      temporaryThumbnailFile.deleteSync(recursive: true);
      return copiedThumbnailImage;
    } catch (e) {
      print("Failed to get thumbnail.");
      print("Reason: " + e.toString());
      return null;
    }
  }
}