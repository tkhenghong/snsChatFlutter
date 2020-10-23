import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// UI component to display the video file downloaded from the Internet.
class VideoPlayerPage extends StatefulWidget {
  final String heroId;
  final File video;

  VideoPlayerPage({this.heroId, this.video});

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerState();
  }
}

class VideoPlayerState extends State<VideoPlayerPage> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.video);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: VideoPlayer(videoPlayerController),
    );
  }
}
