import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

// Read directories
import 'package:path_provider/path_provider.dart';

import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';



int generateNewId() {
  var random = new Random();
  // Formula: random.nextInt((max - min) + 1) + min;
  int newId = random.nextInt((999999999 - 100000000) + 1) + 100000000;
  return newId;
}



// Will return different widget with working url, just throw the Multimedia object
// Steps:
// First, get local file (fastest)
// No local file, get thumbnail (local) (2nd fastest)
// No local thumbnail, get remote thumbnail (3rd fastest, can assume not local download)
// TODO: Put it into File I/O service
Future<File> loadImageHandler(Multimedia multimedia) async {
  print("loadImageHandler()");
  // Local
  Directory extDirectory = await getExternalStorageDirectory();
  print("extDirectory.path: " + extDirectory.path);
  String localFullFileUrl = extDirectory.path + multimedia.localFullFileUrl;
  String localThumbnailUrl = extDirectory.path + multimedia.localThumbnailUrl;
  print("localFullFileUrl: " + localFullFileUrl);

  File localFullFile = new File(localFullFileUrl);
  File localThumbnailFile = new File(localThumbnailUrl);

  // Get local file
  bool localFullFileExist = await localFullFile.exists();
  bool localThumbnailFileExist = await localThumbnailFile.exists();

  if (localFullFileExist) {
    print('if (localFullFileExist)');
    return localFullFile;
  } else {
    // Thumbnail
    if (localThumbnailFileExist) {
      print('if (!localThumbnailFileExist)');
      return localThumbnailFile;
    }
  }


  if (!localThumbnailFileExist) {
    print('if (!localThumbnailFileExist)');
    // Both file not exist means not yet download

    return getImageFromNetwork(multimedia.remoteThumbnailUrl);

//      CachedNetworkImage(imageUrl: multimedia.remoteThumbnailUrl,
//        placeholder: (context, url) => CircularProgressIndicator(),
//        errorWidget: (context, url, error) => new Icon(Icons.error)); // Return unloadable network image
  } else {
//    final response = await http.get(multimedia.remoteUrl);
  }

  return File('');
}


Future<File> getImageFromNetwork(String url) async {
  return await CachedNetworkImageProvider(url).cacheManager.getSingleFile(url);
}
