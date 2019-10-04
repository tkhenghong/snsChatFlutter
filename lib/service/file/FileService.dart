import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/permissions/PermissionService.dart';

class FileService {
  PermissionService permissionService = PermissionService();

  // TODO: getApplicationDocumentDirectory should change to getDirectories,
  // TODO: so you can get any directory based on where you want.
  Future<String> getApplicationDocumentDirectory() async {
    bool storageAccessGranted = await permissionService.requestStoragePermission();
    if (storageAccessGranted) {
      // get the application documents directory
//      var dir = await getApplicationDocumentsDirectory();
    // TODO: Testing directory. Original should be the above code
      var dir = await getExternalStorageDirectory();
      // make sure it exists
      await dir.create(recursive: true);
      return dir.path; // join method comes from path.dart
    } else {
      return null;
    }
  }

  Future<File> copyFile(File fileToBeCopied, String directory) async {
    if (isObjectEmpty(fileToBeCopied)) {
      return null;
    }

    // Retrieve file name
    int lastSlash = fileToBeCopied.path.lastIndexOf("/");
    String fileName = fileToBeCopied.path.substring(lastSlash+1, fileToBeCopied.path.length);

    String destinationFilePath = "";

    switch (directory) {
      case "ApplicationDocumentDirectory":
        destinationFilePath = await getApplicationDocumentDirectory();
        break;
      default:
        break;
    }

    if(!isStringEmpty(destinationFilePath)) {
      destinationFilePath = destinationFilePath + fileName;
    }

    print("destinationFilePath: " + destinationFilePath);

    try {
      File copiedFile = await fileToBeCopied.copy(destinationFilePath);
      print("copiedFile.path: " + copiedFile.path);
      return copiedFile;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error in file copying.");
      print("Error in file copying.");
      print("Reason: " + e.toString());
      return null;
    }
  }

  Future<File> downloadFileFromUint8List(Uint8List rawFile, String fileName, String fileFormat) async {
    try {
      String path = await getApplicationDocumentDirectory();
      String fileFullPath = path + "/" + fileName + "." + fileFormat;
      print("fileFullPath: " + fileFullPath);
      File file = await File(fileFullPath).writeAsBytes(rawFile);
      bool fileExist = await file.exists();
      print("fileExist: " + fileExist.toString());
      File copiedFile = await file.copy(fileFullPath);
      print("copiedFile.path: " + copiedFile.path);
      return copiedFile;
    } catch (e) {
      print("downloadFileFromUint8List error");
      print("e: " + e.toString());
      return null;
    }
  }

  // Check if file exist
  Future<File> getFile(String filePath) async {
    try {
      File file = File(filePath);
      bool fileExists = await file.exists();
      if (!fileExists) {
        return null;
      }
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<File> getLocalImage(Multimedia multimedia, String type) async {
    if (!isStringEmpty(multimedia.localFullFileUrl)) {
      File file = await getFile(multimedia.localFullFileUrl);
      if (!isObjectEmpty(file)) {
        return file;
      }
    }
    if (!isStringEmpty(multimedia.localThumbnailUrl)) {
      File file = await getFile(multimedia.localThumbnailUrl);
      if (!isObjectEmpty(file)) {
        return null;
      }
    }

    return null;

    // TODO: Download remote file using remoteThumbnailUrl && remoteFullUrl
//    if(!isStringEmpty(multimedia.remoteThumbnailUrl)) {
//      File file = await getFile(multimedia.localThumbnailUrl);
//      if(!isObjectEmpty(file)) {
//        return null;
//      }
//    }
  }

  String getDefaultImagePath(String type) {
    switch (type) {
      case "Personal":
        return "lib/ui/icons/single_conversation.png";
        break;
      case "Group":
        return "lib/ui/icons/group_conversation.png";
        break;
      case "Broadcast":
        return "lib/ui/icons/broadcast_conversation.png";
        break;
      case "Profile":
        return "lib/ui/icons/default_user_icon.png";
        break;
      default:
        return "lib/ui/icons/none.png";
        break;
    }
  }
}
