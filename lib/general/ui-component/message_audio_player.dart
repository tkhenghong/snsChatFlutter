import 'package:flutter/material.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';

import 'package:snschat_flutter/objects/index.dart';
import 'package:snschat_flutter/service/index.dart';

Widget messageAudioPlayer(BuildContext context, ChatMessage message, Multimedia userMultimedia, Multimedia multimedia, AudioService audioService) {
  if (!isObjectEmpty(multimedia)) {
    return Column(
      children: <Widget>[
        IconButton(
//          icon: audioService.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          icon: Icon(Icons.play_arrow),
          onPressed: () {
//            if(audioService.isPlaying) {
//              audioService.pauseResumeAudio();
//            } else {
//              audioService.startAudio(multimedia.remoteFullFileUrl);
//            }
          },
        ),
        Slider.adaptive(
          value: audioService.sliderCurrentPosition,
          label: message.messageContent,
//          max: audioService.audioMaxDuration,
          max: 5.0,
          onChanged: (double sliderPositionValue) {
//            audioService.seekAudioPosition(sliderPositionValue);
          },
        ),

      ],
    );
  } else {
    return Text('Audio error');
  }
}
