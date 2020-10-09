import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/service/index.dart';

class PhotoViewPage extends StatefulWidget {
  final Multimedia multimedia;

  PhotoViewPage([this.multimedia]);

  @override
  State<StatefulWidget> createState() {
    return new PhotoViewState();
  }
}

class PhotoViewState extends State<PhotoViewPage> {
  File displayingFile;

  ImageService imageService = Get.find();
  CustomFileService customfileService = Get.find();

  PhotoViewController photoViewController = PhotoViewController();

  DefaultCacheManager defaultCacheManager = DefaultCacheManager();

  @override
  Widget build(BuildContext context) {
    if (widget.multimedia.localFullFileUrl.isNotEmpty) {
      displayingFile = File(widget.multimedia.localFullFileUrl);
      return PhotoView(
          heroAttributes: PhotoViewHeroAttributes(tag: widget.multimedia.id),
          loadingBuilder: (context, event) => Image.asset(customfileService.getDefaultImagePath(DefaultImagePathType.ConversationGroupMessage)),
          imageProvider: FileImage(displayingFile));
    } else {
      customfileService.downloadMultimediaFile(context, widget.multimedia);

      return PhotoView(
          loadingBuilder: (context, event) => Image.asset(customfileService.getDefaultImagePath(DefaultImagePathType.ConversationGroupMessage)),
          imageProvider: NetworkImage(widget.multimedia.remoteThumbnailUrl));
    }
  }

  fileInfoIsEmpty(FileInfo fileInfo) {
    return fileInfo.isNull || fileInfo.file.isNull;
  }

  AssetImage loadDefaultAssetImage() {
    return AssetImage(customfileService.getDefaultImagePath(DefaultImagePathType.ConversationGroupMessage));
  }
}
