import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/service/file/FileService.dart';

// Used for Record and play audio
class AudioService {
  String AUDIO_DIRECTORY = globals.AUDIO_DIRECTORY;
  Stream<bool> _isRecording = Stream.value(false);
  String dateText;
  double _dbLevel;
  String audioFilePath;
  bool audioClose = false;

  t_CODEC _codec = t_CODEC.CODEC_AAC;

  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;

  FlutterSound flutterSound;
  FileService fileService;

  // A value for your Widget Slider so that it will point to that position when you move the pointer in the slider or load back the position of the slider
  Stream<double> sliderCurrentPosition;

  // Show audio file max duration
  Stream<double> audioMaxDuration;

  // Show current player duration
  Stream<String> playerCurrentDuration;

  initService() {
    flutterSound = new FlutterSound();
    fileService = new FileService();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  Future<bool> startRecorder() async {
    try {
      initService();
      String path = await flutterSound.startRecorder(
        codec: _codec,
      );

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt(), isUtc: true);
        String dateText = DateFormat('mm:ss:SS', 'en_GB').format(date); // Here got problem
        this.dateText = dateText;
      });
      _dbPeakSubscription = flutterSound.onRecorderDbPeakChanged.listen((value) {
        this._dbLevel = value;
        this._isRecording.transform(_setStreamBooleanValue(true));
        this.audioFilePath = path;
      });
      return true;
    } catch (err) {
      print('AudioService.dart Failed to start recoring audio.');
      print('AudioService.dart err: ' + err.toString());
      this._isRecording.transform(_setStreamBooleanValue(false));
      return false;
    }
  }

  Future<bool> stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }
      this._isRecording.transform(_setStreamBooleanValue(true));
      return true;
    } catch (err) {
      print('AudioService.dart Failed to stop recoring audio.');
      print('AudioService.dart err: ' + err.toString());
      this._isRecording.transform(_setStreamBooleanValue(false));
      return false;
    }
  }

  // Assuming local URL
  Future<bool> startAudio(String audioUrl) async {
    sliderCurrentPosition = Stream.value(0.0);
    audioMaxDuration = Stream.value(0.0);
    try {
      String path = await flutterSound.startPlayer(audioUrl);

      if (isStringEmpty(path)) {
        return false;
      }

      await flutterSound.setVolume(1.0);

      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        print('AudioService.dart flutterSound.onPlayerStateChanged listener activated.');
        if (e != null) {
          print('AudioService.dart if (e != null)');

          sliderCurrentPosition.transform(_setStreamDoubleValue(e.currentPosition));
          audioMaxDuration.transform(_setStreamDoubleValue(e.duration));

          print('AudioService.dart sliderCurrentPosition: ' + sliderCurrentPosition.toString());
          print('AudioService.dart audioMaxDuration: ' + audioMaxDuration.toString());
        }
      });
      return true;
    } catch (err) {
      print('AudioService.dart Failed to start audio.');
      print('AudioService.dart err: ' + err.toString());
      return false;
    }
  }

  Future<bool> pauseAudio() async {
    print('AudioService.dart pauseAudio()');
    String result;
    try {
      if (flutterSound.audioState == t_AUDIO_STATE.IS_PAUSED) {
        result = await flutterSound.resumePlayer();
        print('resumePlayer: $result');
      } else {
        result = await flutterSound.pausePlayer();
        print('pausePlayer: $result');
      }
      return true;
    } catch (err) {
      print('AudioService.dart Failed to pause/resume audio.');
      print('AudioService.dart err: ' + err.toString());
      return false;
    }
  }

  Future<bool> stopPlayer() async {
    try {
      String result = await flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }

      sliderCurrentPosition.transform(_setStreamDoubleValue(0.0));
//      sliderCurrentPosition = 0.0;

      return true;
    } catch (err) {
      print('AudioService.dart Failed to stop audio.');
      print('AudioService.dart err: ' + err.toString());
      return false;
    }
  }

  // Only during playing
  // This will make FlutterSound plugin to find the time from the position value that your have given and play audio from that time.
  Future<bool> seekAudioPosition(double sliderPositionValue) async {
    print('AudioService.dart seekAudioPosition()');
    print('AudioService.dart sliderPositionValue: ' + sliderPositionValue.toString());
    try {
      await flutterSound.seekToPlayer(sliderPositionValue.toInt());
      return true;
    } catch (err) {
      print('AudioService.dart Failed to seek Audio position.');
      print('AudioService.dart err: ' + err.toString());
      return false;
    }
  }

  StreamTransformer<bool, bool> _setStreamBooleanValue(bool booleanValue) {
    print('AudioService.dart setStreamBooleanValue()');
    print('AudioService.dart booleanValue: ' + booleanValue.toString());
    return StreamTransformer<bool, bool>.fromHandlers(handleData: (value, sink) {
      sink.add(booleanValue);
    });
  }

  StreamTransformer<double, double> _setStreamDoubleValue(double doubleValue) {
    print('AudioService.dart setStreamDoubleValue()');
    print('AudioService.dart doubleValue: ' + doubleValue.toString());
    return StreamTransformer<double, double>.fromHandlers(handleData: (value, sink) {
      sink.add(doubleValue);
    });
  }

  Future<bool> _stopAllStreams() async {
    audioClose = true;
    return true;
  }
}
