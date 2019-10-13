import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/FirebaseStorage/FirebaseStorageService.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:image/image.dart' as CustomImage;
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppBloc.dart';
import 'package:snschat_flutter/state/bloc/WholeApp/WholeAppEvent.dart';

class ImageService {
  FileService fileService = FileService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();
  WholeAppBloc wholeAppBloc;

  // TODO: Stop using this, use cachedNetworkImage widget, but need to know
  // Returns ImageProvider object
  // Image local thumbnail -> Image remote thumbnail -> Image remote full file
  // Remember, ONLY load full file when view it in whole screen.
  // Full file is not as important as thumbnail. (Thumbnails directories MUST be there)
  // Network file can gone, but thumbnails are always secured in local storage
  // (In local storage, you're unable to delete it manually, plus,
  // network storage always have a thumbnail copy of it, full file is removable(except UserContact photo))
  // @param context: For bring in WholeAppBloc so that it can dispatch events
  ImageProvider processImageThumbnail(Multimedia multimedia, String type, BuildContext context) {
    if (isObjectEmpty(multimedia) || isStringEmpty(type)) {
      return AssetImage(fileService.getDefaultImagePath(type));
    }
    try {
      File file = File(multimedia.localThumbnailUrl); // Image.file(file).image;
      fileService.getFile(multimedia.localThumbnailUrl).then((File file) {
        if (isObjectEmpty(file)) {
          downloadThumbnailFileAndUpdateMultimedia(multimedia, context);
        }
      });
      return FileImage(file);
    } catch (e) {
      print("Thumbnail file is missing");
      print("Reason: " + e.toString());
      // TODO: Use FileService to download file, get the File object, get it's remoteURL and update the localDB and State of Multimedia object, setState(){}
      downloadThumbnailFileAndUpdateMultimedia(multimedia, context);
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

  // Only handles thumbnail download
  downloadThumbnailFileAndUpdateMultimedia(Multimedia multimedia, BuildContext context) async {
    fileService.downloadFile(multimedia.remoteThumbnailUrl, true, true).then((File file) {
      if (!isObjectEmpty(file)) {
        multimedia.localThumbnailUrl = file.path;
        wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
        // Don't update it in REST
        wholeAppBloc.dispatch(EditMultimediaEvent(
            multimedia: multimedia, updateInREST: false, updateInDB: true, updateInState: true, callback: (Multimedia multimedia) {}));
      }
    });
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
