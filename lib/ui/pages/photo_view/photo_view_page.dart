import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/index.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:snschat_flutter/service/file/FileService.dart';
import 'package:snschat_flutter/service/image/ImageService.dart';

class PhotoViewPage extends StatelessWidget {
  final Multimedia multimedia;
  File displayingFile;

  ImageService imageService = ImageService();
  FileService fileService = FileService();

  PhotoViewController photoViewController = PhotoViewController();

  DefaultCacheManager defaultCacheManager = DefaultCacheManager();

  PhotoViewPage([this.multimedia]);

  @override
  Widget build(BuildContext context) {
    if (!isObjectEmpty(multimedia.localFullFileUrl)) {
      displayingFile = File(multimedia.localFullFileUrl);
      return PhotoView(
          heroAttributes: PhotoViewHeroAttributes(tag: multimedia.id),
          loadingChild: Image.asset(fileService.getDefaultImagePath('ConversationGroupMessage')),
          imageProvider: FileImage(displayingFile));
    } else {
      fileService.downloadMultimediaFile(context, multimedia);

      return PhotoView(
          loadingChild: Image.asset(fileService.getDefaultImagePath('ConversationGroupMessage')),
          imageProvider: NetworkImage(multimedia.remoteThumbnailUrl));
    }
  }

  fileInfoIsEmpty(FileInfo fileInfo) {
    return isObjectEmpty(fileInfo) || isObjectEmpty(fileInfo.file);
  }

  AssetImage loadDefaultAssetImage() {
    return AssetImage(fileService.getDefaultImagePath('ConversationGroupMessage'));
  }
}
