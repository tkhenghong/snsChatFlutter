import 'dart:io';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
// import 'package:image/image.dart' as CustomImage;
import 'package:snschat_flutter/environments/development/variables.dart'
as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/service/index.dart';

class ImageService {
  CustomFileService fileService = Get.find();
  FirebaseStorageService firebaseStorageService = Get.find();

  static int imageThumbnailWidthSize = globals.imageThumbnailWidthSize;

  Widget loadImageThumbnailCircleAvatar(Multimedia multimedia, DefaultImagePathType type) {
    return isObjectEmpty(multimedia)
        ? defaultImage(type)
        : isStringEmpty(multimedia.remoteThumbnailUrl)
            ? defaultImage(type)
            : CachedNetworkImage(
                // Note: imageBuilder is a place that tell CachedNetworkImage how the image should be displayed
                imageBuilder: (BuildContext context, ImageProvider<dynamic> imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                  );
                },
                useOldImageOnUrlChange: true,
                imageUrl: multimedia.remoteThumbnailUrl.toString(),
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  fileService.getDefaultImagePath(type),
                ),
              );
  }

  Widget defaultImage(DefaultImagePathType type) {
    return CircleAvatar(
      backgroundImage: AssetImage(fileService.getDefaultImagePath(type)),
    );
  }

  Widget loadFullImage(BuildContext context, Multimedia multimedia, DefaultImagePathType type) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    double width = deviceWidth * 0.65;
    double height = deviceHeight * 0.4;
    try {
      if (!isObjectEmpty(multimedia.localFullFileUrl)) {
        File localImagefile = File(multimedia.localFullFileUrl);

        localImagefile.exists().then((bool exist) {
          if (!exist) {
            redownloadMultimediaFile(context, multimedia);
          }
        });
        return Image.file(
          localImagefile,
          fit: BoxFit.cover,
          width: width,
          height: height,
        );
      } else {
        redownloadMultimediaFile(context, multimedia);

        return CachedNetworkImage(
          useOldImageOnUrlChange: true,
          imageUrl: multimedia.remoteFullFileUrl,
          placeholder: (context, url) => CachedNetworkImage(
            useOldImageOnUrlChange: true,
            imageUrl: multimedia.remoteThumbnailUrl,
            width: width,
            height: height,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              fileService.getDefaultImagePath(type),
              width: width,
              height: height,
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(
            fileService.getDefaultImagePath(type),
            width: width,
            height: height,
          ),
        );
      }
    } catch (e) {
      print('ImageService.dart loadFullImage() error');
      print('ImageService.dart e: ' + e.toString());
      redownloadMultimediaFile(context, multimedia);
      return Image.asset(
        fileService.getDefaultImagePath(type),
        width: width,
        height: height,
      );
    }
  }

  redownloadMultimediaFile(BuildContext context, Multimedia multimedia) {
    if (!isObjectEmpty(multimedia) && !isStringEmpty(multimedia.remoteFullFileUrl)) {
      fileService.downloadMultimediaFile(context, multimedia);
    }
  }

  // Isolate solution: https://github.com/brendan-duncan/image/wiki/Examples
  // Down there, there's an example of using isolate to processing something about the photo so that it won't eat up the UI thread
  Future<File> getImageThumbnail(File imageFile) async {
    try {
      ReceivePort receivePort = ReceivePort();

      await Isolate.spawn(createThumbnail, DecodeParam(imageFile, receivePort.sendPort));

      // Get the processed image from the isolate.
      // CustomImage.Image thumbnailImage = await receivePort.first;

      // String fullThumbnailDirectory = await fileService.getApplicationDocumentDirectory() + "/" + "thumbnail-" + new DateTime.now().millisecondsSinceEpoch.toString() + ".png";
      // Put it into our directory, set it as temp.png first (File format: FILEPATH/thumbnail-95102006192014.png)
      // File thumbnailFile = new File(fullThumbnailDirectory)..writeAsBytesSync(CustomImage.encodePng(thumbnailImage));
      File thumbnailFile; // temporary

      // Fix thumbnail not rotated properly when created.
      // Link: https://pub.dev/packages/flutter_exif_rotation
//      thumbnailFile =
//          await FlutterExifRotation.rotateImage(path: thumbnailFile.path);

      return thumbnailFile;
    } catch (e) {
      print("Failed to get thumbnail.");
      print("Reason: " + e.toString());
      return null;
    }
  }

  static void createThumbnail(DecodeParam param) async {
    // CustomImage.Image image = CustomImage.decodeImage(param.file.readAsBytesSync());

    // CustomImage.Image thumbnail = CustomImage.copyResize(image, width: imageThumbnailWidthSize);

    // param.sendPort.send(thumbnail);
  }
}

class DecodeParam {
  final File file;
  final SendPort sendPort;

  DecodeParam(this.file, this.sendPort);
}
