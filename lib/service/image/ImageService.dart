import 'dart:io';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/FirebaseStorage/FirebaseStorageService.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:image/image.dart' as CustomImage;
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;

class ImageService {
  FileService fileService = FileService();
  FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  static int imageThumbnailWidthSize = globals.imageThumbnailWidthSize;

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

  Widget loadImageThumbnailCircleAvatar(Multimedia multimedia, String type, BuildContext context) {
    Color appBarTextTitleColor = Theme.of(context).appBarTheme.textTheme.title.color;

    return isObjectEmpty(multimedia)
        ? defaultImage(appBarTextTitleColor, type)
        : isStringEmpty(multimedia.remoteThumbnailUrl)
            ? defaultImage(appBarTextTitleColor, type)
            : CachedNetworkImage(
                // Note: imageBuilder is a place that tell CachedNetworkImage how the image should be displayed
                imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                  return CircleAvatar(
                    backgroundColor: appBarTextTitleColor,
                    backgroundImage: imageProvider,
                  );
                },
                useOldImageOnUrlChange: true,
                imageUrl: multimedia.remoteThumbnailUrl.toString(),
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  fileService.getDefaultImagePath(type),
                  color: appBarTextTitleColor,
                ),
              );
  }

  Widget defaultImage(Color appBarTextTitleColor, String type) {
    return CircleAvatar(
      backgroundColor: appBarTextTitleColor,
      backgroundImage: AssetImage(fileService.getDefaultImagePath(type)),
    );
  }

  Widget loadFullImage(Multimedia multimedia, String type) {
    return isObjectEmpty(multimedia)
        ? Image.asset(fileService.getDefaultImagePath(type))
        : isStringEmpty(multimedia.remoteThumbnailUrl)
            ? Image.asset(fileService.getDefaultImagePath(type))
            : CachedNetworkImage(
                useOldImageOnUrlChange: true,
                imageUrl: multimedia.remoteFullFileUrl,
                placeholder: (context, url) => CachedNetworkImage(
                  useOldImageOnUrlChange: true,
                  imageUrl: multimedia.remoteThumbnailUrl,
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset(fileService.getDefaultImagePath(type)),
                ),
                errorWidget: (context, url, error) => Image.asset(fileService.getDefaultImagePath(type)),
              );
  }

  // Only handles thumbnail download
  downloadThumbnailFileAndUpdateMultimedia(Multimedia multimedia, BuildContext context) async {
    fileService.downloadFile(multimedia.remoteThumbnailUrl, true, true).then((File file) {
      if (!isObjectEmpty(file)) {
        multimedia.localThumbnailUrl = file.path;
//        wholeAppBloc = BlocProvider.of<WholeAppBloc>(context);
        // Don't update it in REST

//        wholeAppBloc.dispatch(EditMultimediaEvent(
//            multimedia: multimedia, updateInREST: false, updateInDB: true, updateInState: true, callback: (Multimedia multimedia) {}));
      }
    });
  }

  // Isolate solution: https://github.com/brendan-duncan/image/wiki/Examples
  // Down there, there's an example of using isolate to processing something about the photo so that it won't eat up the UI thread
  Future<File> getImageThumbnail(File imageFile) async {
    print("getImageThumbnail()");
    try {
      ReceivePort receivePort = ReceivePort();

      await Isolate.spawn(createThumbnail,
          DecodeParam(imageFile, receivePort.sendPort));

      // Get the processed image from the isolate.
      CustomImage.Image thumbnailImage = await receivePort.first;

      String fullThumbnailDirectory = await fileService.getApplicationDocumentDirectory() +
          "/" +
          "thumbnail-" +
          new DateTime.now().millisecondsSinceEpoch.toString() +
          ".png";
      // Put it into our directory, set it as temp.png first (File format: FILEPATH/thumbnail-95102006192014.png)
      File thumbnailFile = new File(fullThumbnailDirectory)..writeAsBytesSync(CustomImage.encodePng(thumbnailImage));

      // Fix thumbnail not rotated properly when created.
      // Link: https://pub.dev/packages/flutter_exif_rotation
      thumbnailFile = await FlutterExifRotation.rotateImage(path: thumbnailFile.path);

      return thumbnailFile;
    } catch (e) {
      print("Failed to get thumbnail.");
      print("Reason: " + e.toString());
      return null;
    }
  }



  // Create thumbnail
  static void createThumbnail(DecodeParam param) async {

    CustomImage.Image image = CustomImage.decodeImage(param.file.readAsBytesSync());

    CustomImage.Image thumbnail = CustomImage.copyResize(image, width: imageThumbnailWidthSize);

    param.sendPort.send(thumbnail);
  }
}

class DecodeParam {
  final File file;
  final SendPort sendPort;
  DecodeParam(this.file, this.sendPort);
}
