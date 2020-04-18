//import 'dart:async';
//import 'dart:io';
//import 'dart:math';
//import 'dart:typed_data';
//import 'package:flutter_sound/flauto.dart';
//import 'package:flutter_sound/flutter_sound_player.dart';
//import 'package:flutter_sound/flutter_sound_recorder.dart';
//import 'package:flutter_sound/track_player.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:intl/intl.dart';
//import 'package:flutter/services.dart' show rootBundle;

//import 'package:snschat_flutter/environments/development/variables.dart'
//    as globals;
//import 'package:snschat_flutter/general/index.dart';
//import 'package:snschat_flutter/service/index.dart';

//enum t_MEDIA {
//  FILE,
//  BUFFER,
//  ASSET,
//  STREAM,
//  REMOTE_EXAMPLE_FILE,
//}

// Used for Record and play audio
class AudioService {
//  bool REENTRANCE_CONCURENCY = false;
//  final exampleAudioFilePath =
//      "https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3";
//  final albumArtPath =
//      "https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_500kB.png";

//  bool _isRecording = false;
//  List<String> _path = [null, null, null, null, null, null, null];
//  StreamSubscription _recorderSubscription;
//  StreamSubscription _dbPeakSubscription;
//  StreamSubscription _playerSubscription;
//  StreamSubscription _playbackStateSubscription;

//  FlutterSoundPlayer playerModule;
//  FlutterSoundRecorder recorderModule;
//  FlutterSoundPlayer playerModule_2; // Used if REENTRANCE_CONCURENCY
//  FlutterSoundRecorder recorderModule_2; // Used if REENTRANCE_CONCURENCY

//  String _recorderTxt = '00:00:00';
//  String _playerTxt = '00:00:00';
//  double _dbLevel;

//  double sliderCurrentPosition = 0.0;
//  double maxDuration = 1.0;
//  t_MEDIA _media = t_MEDIA.FILE;
//  t_CODEC _codec = t_CODEC.CODEC_AAC;

//  bool _encoderSupported = true; // Optimist
//  bool _decoderSupported = true; // Optimist

  // Whether the user wants to use the audio player features
//  bool _isAudioPlayer = false;
//  bool _duckOthers = false;

//  double _duration = null;

//  static const List<String> paths = [
//    'flutter_sound_example.aac', // DEFAULT
//    'flutter_sound_example.aac', // CODEC_AAC
//    'flutter_sound_example.opus', // CODEC_OPUS
//    'flutter_sound_example.caf', // CODEC_CAF_OPUS
//    'flutter_sound_example.mp3', // CODEC_MP3
//    'flutter_sound_example.ogg', // CODEC_VORBIS
//    'flutter_sound_example.pcm', // CODEC_PCM
//  ];

//  List<String> assetSample = [
//    'assets/samples/sample.aac',
//    'assets/samples/sample.aac',
//    'assets/samples/sample.opus',
//    'assets/samples/sample.caf',
//    'assets/samples/sample.mp3',
//    'assets/samples/sample.ogg',
//    'assets/samples/sample.pcm',
//  ];

//  Future<bool> fileExists(String path) async {
//    return await File(path).exists();
//  }
//
//  initService() async {
//    playerModule = await FlutterSoundPlayer().initialize();
//    recorderModule = await FlutterSoundRecorder().initialize();
//
//    await recorderModule.setDbPeakLevelUpdate(0.8);
//    await recorderModule.setDbLevelEnabled(true);
//    await recorderModule.setDbLevelEnabled(true);
//    if (REENTRANCE_CONCURENCY) {
//      playerModule_2 = await FlutterSoundPlayer().initialize();
//      await playerModule_2.setSubscriptionDuration(0.01);
//      await playerModule_2.setSubscriptionDuration(0.01);
//
//      recorderModule_2 = await FlutterSoundRecorder().initialize();
//      await recorderModule_2.setSubscriptionDuration(0.01);
//      await recorderModule_2.setDbPeakLevelUpdate(0.8);
//      await recorderModule_2.setDbLevelEnabled(true);
//    }
//  }
//
//  Future<void> getDuration() async {
//    switch (_media) {
//      case t_MEDIA.FILE:
//      case t_MEDIA.BUFFER:
//        int d = await flutterSoundHelper.duration(this._path[_codec.index]);
//        _duration = d != null ? d / 1000.0 : null;
//        break;
//      case t_MEDIA.ASSET:
//        _duration = null;
//        break;
//      case t_MEDIA.STREAM:
//      case t_MEDIA.REMOTE_EXAMPLE_FILE:
//        _duration = null;
//        break;
//    }
//    // setState(() {});
//  }
//
//  Future<bool> stopRecorder() async {
//    try {
//      String result = await recorderModule.stopRecorder();
//      print('stopRecorder: $result');
//      cancelRecorderSubscriptions();
//      if (REENTRANCE_CONCURENCY) {
//        await recorderModule_2.stopRecorder();
//        await playerModule_2.stopPlayer();
//      }
//      getDuration();
//    } catch (err) {
//      print('stopRecorder error: $err');
//    }
//    // this.setState(() {
//    this._isRecording = false;
//    // });
//  }
//
//  Future<bool> startRecorder() async {
//    try {
//      // String path = await flutterSoundModule.startRecorder
//      // (
//      //   paths[_codec.index],
//      //   codec: _codec,
//      //   sampleRate: 16000,
//      //   bitRate: 16000,
//      //   numChannels: 1,
//      //   androidAudioSource: AndroidAudioSource.MIC,
//      // );
//      Directory tempDir = await getTemporaryDirectory();
//
//      String path = await recorderModule.startRecorder(
//        uri: '${tempDir.path}/${recorderModule.slotNo}-${paths[_codec.index]}',
//        codec: _codec,
//      );
//      print('startRecorder: $path');
//
//      _recorderSubscription = recorderModule.onRecorderStateChanged.listen((e) {
//        if (e != null && e.currentPosition != null) {
//          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//              e.currentPosition.toInt(),
//              isUtc: true);
//          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//
//          // this.setState(() {
//          this._recorderTxt = txt.substring(0, 8);
//          // });
//        }
//      });
//      _dbPeakSubscription =
//          recorderModule.onRecorderDbPeakChanged.listen((value) {
//        print("got update -> $value");
//        // setState(() {
//        this._dbLevel = value;
//        // });
//      });
//      if (REENTRANCE_CONCURENCY) {
//        try {
//          Uint8List dataBuffer =
//              (await rootBundle.load(assetSample[_codec.index]))
//                  .buffer
//                  .asUint8List();
//          await playerModule_2.startPlayerFromBuffer(dataBuffer, codec: _codec,
//              whenFinished: () {
//            //await playerModule_2.startPlayer(exampleAudioFilePath, codec: t_CODEC.CODEC_MP3, whenFinished: () {
//            print('Secondary Play finished');
//          });
//        } catch (e) {
//          print('startRecorder error: $e');
//        }
//        await recorderModule_2.startRecorder(
//          uri: '${tempDir.path}/flutter_sound_recorder2.aac',
//          codec: t_CODEC.CODEC_AAC,
//        );
//        print(
//            "Secondary record is '${tempDir.path}/flutter_sound_recorder2.aac'");
//      }
//
//      // this.setState(() {
//      this._isRecording = true;
//      this._path[_codec.index] = path;
//      // });
//    } catch (err) {
//      print('startRecorder error: $err');
//      // setState(() {
//      stopRecorder();
//      this._isRecording = false;
//      if (_recorderSubscription != null) {
//        _recorderSubscription.cancel();
//        _recorderSubscription = null;
//      }
//      if (_dbPeakSubscription != null) {
//        _dbPeakSubscription.cancel();
//        _dbPeakSubscription = null;
//      }
//      // });
//    }
//  }
//
//  pauseResumeRecorder() {
//    if (recorderModule.isPaused) {
//      {
//        recorderModule.resumeRecorder();
//        if (REENTRANCE_CONCURENCY) {
//          recorderModule_2.resumeRecorder();
//        }
//      }
//    } else {
//      recorderModule.pauseRecorder();
//      if (REENTRANCE_CONCURENCY) {
//        recorderModule_2.pauseRecorder();
//      }
//    }
//
//    void _addListeners() {
//      cancelPlayerSubscriptions();
//      _playerSubscription = playerModule.onPlayerStateChanged.listen((e) {
//        if (e != null) {
//          maxDuration = e.duration;
//          if (maxDuration <= 0) maxDuration = 0.0;
//
//          sliderCurrentPosition = min(e.currentPosition, maxDuration);
//          if (sliderCurrentPosition < 0.0) {
//            sliderCurrentPosition = 0.0;
//          }
//
//          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//              e.currentPosition.toInt(),
//              isUtc: true);
//          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
////          this.setState(() {
//          //this._isPlaying = true;
//          this._playerTxt = txt.substring(0, 8);
////          });
//        }
//      });
//    }
//
//    Future<bool> stopPlayer() async {
//      try {
//        String result = await playerModule.stopPlayer();
//        print('stopPlayer: $result');
//        if (_playerSubscription != null) {
//          _playerSubscription.cancel();
//          _playerSubscription = null;
//        }
//        sliderCurrentPosition = 0.0;
//      } catch (err) {
//        print('error: $err');
//      }
//      if (REENTRANCE_CONCURENCY) {
//        try {
//          String result = await playerModule_2.stopPlayer();
//          print('stopPlayer_2: $result');
//        } catch (err) {
//          print('error: $err');
//        }
//      }
//
//      // this.setState(() {
//      //this._isPlaying = false;
//      // });
//    }
//
//    // In this simple example, we just load a file in memory.This is stupid but just for demonstration  of startPlayerFromBuffer()
//    Future<Uint8List> makeBuffer(String path) async {
//      try {
//        if (!await fileExists(path)) return null;
//        File file = File(path);
//        file.openRead();
//        var contents = await file.readAsBytes();
//        print('The file is ${contents.length} bytes long.');
//        return contents;
//      } catch (e) {
//        print(e);
//        return null;
//      }
//    }
//
//    // Assuming local URL
//    Future<bool> startPlayer(String audioUrl) async {
//      try {
//        //final albumArtPath =
//        //"https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_500kB.png";
//
//        String path;
//        Uint8List dataBuffer;
//        String audioFilePath;
//        if (_media == t_MEDIA.ASSET) {
//          dataBuffer = (await rootBundle.load(assetSample[_codec.index]))
//              .buffer
//              .asUint8List();
//        } else if (_media == t_MEDIA.FILE) {
//          // Do we want to play from buffer or from file ?
//          if (await fileExists(_path[_codec.index]))
//            audioFilePath = this._path[_codec.index];
//        } else if (_media == t_MEDIA.BUFFER) {
//          // Do we want to play from buffer or from file ?
//          if (await fileExists(_path[_codec.index])) {
//            dataBuffer = await makeBuffer(this._path[_codec.index]);
//            if (dataBuffer == null) {
//              throw Exception('Unable to create the buffer');
//            }
//          }
//        } else if (_media == t_MEDIA.REMOTE_EXAMPLE_FILE) {
//          // We have to play an example audio file loaded via a URL
//          audioFilePath = exampleAudioFilePath;
//        }
//
//        // Check whether the user wants to use the audio player features
//        if (_isAudioPlayer) {
//          String albumArtUrl;
//          String albumArtAsset;
//          if (_media == t_MEDIA.REMOTE_EXAMPLE_FILE)
//            albumArtUrl = albumArtPath;
//          else {
//            if (Platform.isIOS) {
//              albumArtAsset = 'AppIcon';
//            } else if (Platform.isAndroid) {
//              albumArtAsset = 'AppIcon.png';
//            }
//          }
//
//          final track = Track(
//            trackPath: audioFilePath,
//            dataBuffer: dataBuffer,
//            codec: _codec,
//            trackTitle: "This is a record",
//            trackAuthor: "from flutter_sound",
//            albumArtUrl: albumArtUrl,
//            albumArtAsset: albumArtAsset,
//          );
//
//          TrackPlayer f = playerModule;
//          path = await f.startPlayerFromTrack(
//            track,
//            /*canSkipForward:true, canSkipBackward:true,*/
//            whenFinished: () {
//              print('I hope you enjoyed listening to this song');
//              // setState(() {});
//            },
//            onSkipBackward: () {
//              print('Skip backward');
//              stopPlayer();
//              startPlayer(audioUrl);
//            },
//            onSkipForward: () {
//              print('Skip forward');
//              stopPlayer();
//              startPlayer(audioUrl);
//            },
//          );
//        } else {
//          if (audioFilePath != null) {
//            path = await playerModule.startPlayer(audioFilePath, codec: _codec,
//                whenFinished: () {
//              print('Play finished');
//              // setState(() {});
//            });
//          } else if (dataBuffer != null) {
//            path = await playerModule.startPlayerFromBuffer(dataBuffer,
//                codec: _codec, whenFinished: () {
//              print('Play finished');
//              // setState(() {});
//            });
//          }
//
//          if (path == null) {
//            print('Error starting player');
//            return false;
//          }
//        }
//        _addListeners();
//        if (REENTRANCE_CONCURENCY && _media != t_MEDIA.REMOTE_EXAMPLE_FILE) {
//          Uint8List dataBuffer =
//              (await rootBundle.load(assetSample[_codec.index]))
//                  .buffer
//                  .asUint8List();
//          await playerModule_2.startPlayerFromBuffer(dataBuffer, codec: _codec,
//              whenFinished: () {
//            //playerModule_2.startPlayer(exampleAudioFilePath, codec: t_CODEC.CODEC_MP3, whenFinished: () {
//            print('Secondary Play finished');
//          });
//        }
//
//        print('startPlayer: $path');
//        // await flutterSoundModule.setVolume(1.0);
//      } catch (err) {
//        print('error: $err');
//      }
//      // setState(() {});
//    }
//
//    Future<bool> pauseResumeAudio() async {
//      if (playerModule.isPlaying) {
//        playerModule.pausePlayer();
//        if (REENTRANCE_CONCURENCY) {
//          playerModule_2.pausePlayer();
//        }
//      } else {
//        playerModule.resumePlayer();
//        if (REENTRANCE_CONCURENCY) {
//          playerModule_2.resumePlayer();
//        }
//      }
//    }
//
//    Future<bool> seekAudioPosition(int sliderPositionValue) async {
//      String result = await playerModule.seekToPlayer(sliderPositionValue);
//      print('seekToPlayer: $result');
//    }
//  }
//
//  void cancelRecorderSubscriptions() {
//    if (_recorderSubscription != null) {
//      _recorderSubscription.cancel();
//      _recorderSubscription = null;
//    }
//    if (_dbPeakSubscription != null) {
//      _dbPeakSubscription.cancel();
//      _dbPeakSubscription = null;
//    }
//  }
//
//  void cancelPlayerSubscriptions() {
//    if (_playerSubscription != null) {
//      _playerSubscription.cancel();
//      _playerSubscription = null;
//    }
//
//    if (_playbackStateSubscription != null) {
//      _playbackStateSubscription.cancel();
//      _playbackStateSubscription = null;
//    }
//  }
//
//  Future<void> releaseFlauto() async {
//    try {
//      await playerModule.release();
//      await recorderModule.release();
//      await playerModule_2.release();
//      await recorderModule_2.release();
//    } catch (e) {
//      print('Released unsuccessful');
//      print(e);
//    }
//  }
//
//  setCodec(t_CODEC codec) async {
//    _encoderSupported = await recorderModule.isEncoderSupported(codec);
//    _decoderSupported = await playerModule.isDecoderSupported(codec);
//
//    // setState(() {
//    _codec = codec;
//    // });
//  }
//
//  Future<void> setDuck() async {
//    if (_duckOthers) {
//      if (Platform.isIOS)
//        await playerModule.iosSetCategory(
//            t_IOS_SESSION_CATEGORY.PLAY_AND_RECORD,
//            t_IOS_SESSION_MODE.DEFAULT,
//            IOS_DUCK_OTHERS | IOS_DEFAULT_TO_SPEAKER);
//      else if (Platform.isAndroid)
//        await playerModule.androidAudioFocusRequest(
//            ANDROID_AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK);
//    } else {
//      if (Platform.isIOS)
//        await playerModule.iosSetCategory(
//            t_IOS_SESSION_CATEGORY.PLAY_AND_RECORD,
//            t_IOS_SESSION_MODE.DEFAULT,
//            IOS_DEFAULT_TO_SPEAKER);
//      else if (Platform.isAndroid)
//        await playerModule.androidAudioFocusRequest(ANDROID_AUDIOFOCUS_GAIN);
//    }
//  }
}
