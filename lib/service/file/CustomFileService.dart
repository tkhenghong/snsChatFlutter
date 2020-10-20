import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/service/index.dart';

class CustomFileService {
  PermissionService permissionService = Get.find();
  FileCachingService fileCachingService = Get.find();

  String baseDirectory = '';
  bool baseDirectoryIsReady = false;

  CustomFileService() {
    setBaseDirectory(); // Run this during service startup to get base directory.
  }

  Future<String> setBaseDirectory() async {
    baseDirectoryIsReady = true;
    if (Platform.isAndroid) {
      return baseDirectory = (await (await getExternalStorageDirectory()).create(recursive: true)).path; // Create and return the directory path
    } else if (Platform.isIOS) {
      return baseDirectory = await setBaseDirectory();
    } else if (Platform.isWindows) {
      return baseDirectory = 'C:/';
    } else if (Platform.isMacOS) {
      return baseDirectory = '/tmp/';
    } else if (Platform.isLinux) {
      return baseDirectory = '/tmp/';
    } else if (Platform.isFuchsia) {
      return baseDirectory = '/tmp/';
    } else if (kIsWeb) {
      return baseDirectory = '';
    }

    baseDirectoryIsReady = false;

    // if no condition of the above if else is met, throw Exception.
    throw PlatformException(code: '000', message: 'Error in CustomFileService: Platform is not supported!');
  }

  /// Get the file based on given directory, file name and multimedia type.
  Future<File> getFile(String fileNameWithExtension, MultimediaType multimediaType, {String baseDir}) async {
    checkBaseDirectory();
    if (isObjectEmpty(fileNameWithExtension) || isObjectEmpty(multimediaType)) {
      throw FileSystemException('Error in CustomFileService: File name or multimediaType is missing!');
    }
    if (isObjectEmpty(baseDir)) {
      baseDir = baseDirectory;
    }

    String directory = '$baseDir/${multimediaType.name}/$fileNameWithExtension';

    File file = File(directory);
    if (!(await file.exists())) {
      throw FileSystemException('Error in CustomFileService: Unable to get the File, File does not exist!');
    }
    return file;
  }

  /// This function will try to retrieve the file from local directory.
  /// Not it's not in the given local storage, it wil try to get file from the FileCachingService.
  /// If it's not in the cache storage, it will download the file from the Internet, then download the file
  /// with the given Multimedia object,
  /// NOTE: The file will be stored into the cache storage with the multimedia.fileName by default.
  Future<File> retrieveMultimediaFile(Multimedia multimedia, String url, {String key}) async {
    checkBaseDirectory();
    // Get file with assumed local storage directory.
    File file = File('$baseDirectory/${multimedia.multimediaType}/${multimedia.fileName}');

    if (await file.exists()) {
      return file;
    }

    // Try file in cache storage.
    FileInfo fileInfo = await fileCachingService.getFileFromCache(multimedia.fileName);
    if (!isObjectEmpty(fileInfo.file) && await fileInfo.file.exists()) {
      return fileInfo.file;
    }

    // Download the file and put it into cache storage.
    // Note: May throw Exceptions. Let the caller gets the error.
    FileInfo fileInfoFromInternet = await fileCachingService.downloadFile(url, multimedia.fileName);

    if (!isObjectEmpty(fileInfoFromInternet.file) && await fileInfoFromInternet.file.exists()) {
      return fileInfoFromInternet.file;
    }

    throw FileSystemException('Error in CustomFileService: Unable to retrieve the file.!');
  }

  /// Copy a file from given one to a new directory.
  /// multimediaType: MultimediaType file.
  Future<File> copyFile(File fileToBeCopied, MultimediaType multimediaType) async {
    checkBaseDirectory();

    if (isObjectEmpty(fileToBeCopied)) {
      throw FileSystemException('Error in CustomFileService: Error in copying file, fileToBeCopied or directory is empty!');
    }

    String fileName = getFileName(fileToBeCopied);

    String destinationFilePath = '$baseDirectory/${multimediaType.name}/$fileName';

    try {
      File copiedFile = await fileToBeCopied.copy(destinationFilePath);
      if (!(await copiedFile.exists())) {
        throw FileSystemException('Error in CustomFileService: Error in copying file, copied file does not exist!');
      }

      return copiedFile;
    } catch (e) {
      Fluttertoast.showToast(msg: "Error in file copying. Message: $e}");
      return null;
    }
  }

  /// Create a File object with given directory, file name and multimedia type using Uint8List.
  /// Typically used for files in Contact service(3rd party plugin).
  Future<File> downloadFileFromUINT8List(Uint8List rawFile, String fileNameWithExtension, MultimediaType multimediaType) async {
    checkBaseDirectory();
    String path = '$baseDirectory/${multimediaType.name}/$fileNameWithExtension';
    File file = await File(path).writeAsBytes(rawFile);

    if (!(await file.exists())) {
      throw FileSystemException('Error in CustomFileService: Copied File object does not exist in directory.');
    }

    return file;
  }

  /// Delete a file based on given directory, file name and multimedia type.
  Future<bool> deleteFile({String baseDir, String fileName, MultimediaType multimediaType}) async {
    checkBaseDirectory();
    if (isObjectEmpty(fileName) || isObjectEmpty(multimediaType)) {
      throw FileSystemException('Error in CustomFileService: File name or multimediaType is missing!');
    }
    if (isObjectEmpty(baseDir)) {
      baseDir = baseDirectory;
    }

    String directory = '$baseDir/${multimediaType.name}/$fileName';

    File fileToBeDeleted = File(directory);

    if (!(await fileToBeDeleted.exists())) {
      throw FileSystemException('Error in CustomFileService: Unable to delete a File! File does not exist given the path: $directory.');
    }

    FileSystemEntity fileSystemEntity = await fileToBeDeleted.delete(recursive: true);
    return !(await fileSystemEntity.exists());
  }

  /// Note: It gets the file name WITH the extension.
  String getFileName(File file) {
    return file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
  }

  String getFileNameWithoutExtension(File file) {
    return file.path.substring(file.path.lastIndexOf("/") + 1, file.path.lastIndexOf("."));
  }

  /// Get today in String to save file with date categorization.
  // String getToday() {
  //   return DateFormat('yyyy-MM-dd').format(DateTime.now());
  // }

  checkBaseDirectory() {
    if (!baseDirectoryIsReady) {
      throw FileSystemException('Error in CustomFileService: baseDirectory is empty!');
    }
  }
}
