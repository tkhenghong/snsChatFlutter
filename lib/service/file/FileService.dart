import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
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

  Future<File> downloadFile(String remoteUrl, bool showNotification, bool openFileFromNotification) async {
    print("FileService downloadFile()");
    print("remoteUrl: " + remoteUrl);

    String downloadDirectory = await getApplicationDocumentDirectory() + "/";
    // Create a task
    final taskId = await FlutterDownloader.enqueue(
      url: remoteUrl,
      savedDir: downloadDirectory,
      showNotification: showNotification, // show download progress in status bar (for Android)
      openFileFromNotification: openFileFromNotification, // click on notification to open downloaded file (for Android)
    );

    print("taskId: " + taskId.toString());

    // Execute the tasks
    List<DownloadTask> tasks = await FlutterDownloader.loadTasks();

    print("tasks.length: " + tasks.length.toString());

    tasks.forEach((DownloadTask downloadTask) {
      print("downloadTask.taskId.toString(): " + downloadTask.taskId.toString());
      print("downloadTask.filename.toString(): " + downloadTask.filename.toString());
      print("downloadTask.savedDir.toString(): " + downloadTask.savedDir.toString());
      print("downloadTask.url.toString(): " + downloadTask.url.toString());
      print("downloadTask.status.toString(): " + downloadTask.status.toString());
      print("downloadTask.progress.toString(): " + downloadTask.progress.toString());
      print("Next!");
    });

    print("tasks: " + tasks.toString());

    // Note: The first element of the taskList contains the full information of the file
    String fileDirectory = tasks[0].savedDir.toString();
    String fileName = tasks[0].filename.toString();

    print("fileDirectory: " + fileDirectory);
    print("fileName: " + fileName);

    // Get the file's format
    int lastDot = fileName.lastIndexOf(".");
    String fileFormat = fileName.substring(lastDot + 1, fileName.length);

    print("lastDot: " + lastDot.toString());
    print("fileFormat: " + fileFormat);

    // Rename the file
    File renamedFile = await File(fileDirectory + fileName)
        .rename(downloadDirectory + new DateTime.now().millisecondsSinceEpoch.toString() + "." + fileFormat);

    if (isObjectEmpty(renamedFile) || isStringEmpty(renamedFile.path)) {
      return null;
    }

    print("renamedFile: " + renamedFile.path.toString());

    return renamedFile;
  }

  // TODO: Make a default Icon Image return method
  String getDefaultImagePath(String type) {
    switch (type) {
      case "Personal":
      case "UserContact":
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
//        return "lib/ui/icons/none.png";
        return "lib/ui/icons/default_user_icon.png";
        break;
    }
  }
}
