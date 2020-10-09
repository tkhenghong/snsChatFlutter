import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final Multimedia multimedia;

  VideoPlayerPage([this.multimedia]);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerState();
  }
}

class VideoPlayerState extends State<VideoPlayerPage> {
  File displayingFile;

  DefaultCacheManager defaultCacheManager = DefaultCacheManager();
  VideoPlayerController videoPlayerController;
  bool videoFound = false;

  @override
  void initState() {
    super.initState();
    if (widget.multimedia.localFullFileUrl.isNotEmpty) {
      videoPlayerController = VideoPlayerController.file(File(widget.multimedia.localFullFileUrl));
      videoFound = true;
    } else if (widget.multimedia.remoteFullFileUrl.isNotEmpty) {
      videoPlayerController = VideoPlayerController.network(widget.multimedia.remoteFullFileUrl);
      videoFound = true;
    } else {
      videoFound = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return videoFound
        ? AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          )
        : Material(
            color: Colors.white,
            child: Text('Video Not Found'),
          );
  }
}
