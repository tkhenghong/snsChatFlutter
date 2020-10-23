import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/rest/index.dart';
import 'package:snschat_flutter/service/index.dart';

class PhotoViewPage extends StatefulWidget {
  final String heroId; // An ID to help in Hero animation
  final File photo;
  final DefaultImagePathType defaultImagePathType; // To show the default image if image failed to load.

  PhotoViewPage({this.heroId, this.photo, this.defaultImagePathType});

  @override
  State<StatefulWidget> createState() {
    return new PhotoViewState();
  }
}

class PhotoViewState extends State<PhotoViewPage> {
  CustomFileService customFileService = Get.find();
  HTTPFileService httpFileService = Get.find();

  PhotoViewController photoViewController = PhotoViewController();

  DefaultCacheManager defaultCacheManager = DefaultCacheManager();

  @override
  Widget build(BuildContext context) {
    return PhotoView(heroAttributes: PhotoViewHeroAttributes(tag: widget.heroId), loadingBuilder: (context, event) => Image.asset(widget.defaultImagePathType.path), imageProvider: FileImage(widget.photo));
  }
}
