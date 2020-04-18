import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snschat_flutter/general/functions/validation_functions.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';
import 'package:snschat_flutter/service/permissions/PermissionService.dart';
import 'package:snschat_flutter/state/bloc/bloc.dart';

class CustomFileService {
  PermissionService permissionService = PermissionService();
  DefaultCacheManager defaultCacheManager = DefaultCacheManager();
  List<DownloadTask> tasks = [];

  // TODO: getApplicationDocumentDirectory should change to getDirectories,
  // TODO: so you can get any directory based on where you want.
  Future<String> getApplicationDocumentDirectory() async {
    bool storageAccessGranted = await permissionService.requestStoragePermission();
    if (storageAccessGranted) {
      // get the application documents directory

      // var dir = await getApplicationDocumentsDirectory();
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
    String fileName = fileToBeCopied.path.substring(lastSlash + 1, fileToBeCopied.path.length);

    String destinationFilePath = "";

    switch (directory) {
      case "ApplicationDocumentDirectory":
        destinationFilePath = await getApplicationDocumentDirectory() + "/";
        break;
      default:
        break;
    }

    if (!isStringEmpty(destinationFilePath)) {
      destinationFilePath = destinationFilePath + fileName;
    }

    try {
      File copiedFile = await fileToBeCopied.copy(destinationFilePath);
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
      String path = await getApplicationDocumentDirectory() + "/";
      String fileFullPath = path + fileName + "." + fileFormat;
      File file = await File(fileFullPath).writeAsBytes(rawFile);
      bool fileExist = await file.exists();
      File copiedFile = await file.copy(fileFullPath);
      return copiedFile;
    } catch (e) {
      print("downloadFileFromUint8List error");
      print("Reason: " + e.toString());
      return null;
    }
  }

  downloadMultimediaFile(BuildContext context, Multimedia multimedia) async {
    if (!isStringEmpty(multimedia.remoteFullFileUrl)) {
      File file = await defaultCacheManager.getSingleFile(multimedia.remoteFullFileUrl);
      if (isObjectEmpty(file)) {
        FileInfo fileDownloadFromInternet = await defaultCacheManager.downloadFile(multimedia.remoteFullFileUrl);
        FileInfo fileThumbnailDownloadedFromInternet = await defaultCacheManager.downloadFile(multimedia.remoteThumbnailUrl);

        if (!fileInfoIsEmpty(fileDownloadFromInternet) && !fileInfoIsEmpty(fileThumbnailDownloadedFromInternet)) {
          multimedia.localFullFileUrl = fileDownloadFromInternet.file.path;
          multimedia.localThumbnailUrl = fileThumbnailDownloadedFromInternet.file.path;
          BlocProvider.of<MultimediaBloc>(context).add(EditMultimediaEvent(multimedia: multimedia, callback: (Multimedia multimedia) {}));
        }
      } else {
        multimedia.localFullFileUrl = file.path;
        multimedia.localThumbnailUrl = file.path;
        BlocProvider.of<MultimediaBloc>(context).add(EditMultimediaEvent(multimedia: multimedia, callback: (Multimedia multimedia) {}));
      }
    }
  }

  bool fileInfoIsEmpty(FileInfo fileInfo) {
    return isObjectEmpty(fileInfo) || isObjectEmpty(fileInfo.file);
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
  }

  Future<String> _findLocalPath(BuildContext context) async {
    final platform = Theme.of(context).platform;
    final directory = platform == TargetPlatform.android ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // TODO: bring filename to download the file correctly
  downloadFile(BuildContext context, String remoteUrl, bool showNotification, bool openFileFromNotification, String fileName) async {
    try {
//      String downloadDirectory = await getApplicationDocumentDirectory() + "/";
      String downloadDirectory = await _findLocalPath(context) + "/";

      tasks = await FlutterDownloader.loadTasks();

      // Create a task
      final taskId = await FlutterDownloader.enqueue(
        url: remoteUrl,
        savedDir: downloadDirectory,
        showNotification: showNotification, // show download progress in status bar (for Android)
        openFileFromNotification: openFileFromNotification, // click on notification to open downloaded file (for Android)
      );

      print("taskId: " + taskId.toString());

      FlutterDownloader.registerCallback(flutterDownloaderCallback); // callback is a top-level or static function

      tasks.forEach((DownloadTask downloadTask) {
        print("downloadTask.taskId.toString(): " + downloadTask.taskId.toString());
        print("downloadTask.filename.toString(): " + downloadTask.filename.toString());
        print("downloadTask.savedDir.toString(): " + downloadTask.savedDir.toString());
        print("downloadTask.url.toString(): " + downloadTask.url.toString());
        print("downloadTask.status.toString(): " + downloadTask.status.toString());
        print("downloadTask.progress.toString(): " + downloadTask.progress.toString());
        print("Next!");
      });

      await FlutterDownloader.open(taskId: taskId);
    } catch (e) {
      print('Error when download a file');
      print('Error reason: ' + e.toString());
    }
  }

  static void flutterDownloaderCallback(String id, DownloadTaskStatus downloadTaskStatus, int progress) {
    if (downloadTaskStatus == DownloadTaskStatus.complete) {
      Fluttertoast.showToast(msg: 'File downloaded.', toastLength: Toast.LENGTH_LONG);
      FlutterDownloader.open(taskId: id);
    }
  }

  // TODO: Make a default Icon Image return method
  String getDefaultImagePath(DefaultImagePathType type) {
    switch (type) {
      case DefaultImagePathType.Personal:
      case DefaultImagePathType.UserContact:
        return "lib/ui/icons/single_conversation.png";
        break;
      case DefaultImagePathType.Group:
        return "lib/ui/icons/group_conversation.png";
        break;
      case DefaultImagePathType.Broadcast:
        return "lib/ui/icons/broadcast_conversation.png";
        break;
      case DefaultImagePathType.Profile:
        return "lib/ui/icons/default_user_icon.png";
        break;
      case DefaultImagePathType.ConversationGroupMessage:
        return "lib/ui/icons/conversation_group_message.png";
      default:
//        return "lib/ui/icons/none.png";
        return "lib/ui/icons/default_user_icon.png";
        break;
    }
  }

  Future<bool> deleteFile(String url) async {
    File fileToBeDeleted = new File(url);
    if (await fileToBeDeleted.exists()) {
      FileSystemEntity fileSystemEntity = await fileToBeDeleted.delete(recursive: true);
      return await fileSystemEntity.exists();
    }
    return false; // Means file is not deleted
  }
}
