import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// A service to simplify the usage of Flutter Cache Manager plugin from https://pub.dev/packages/flutter_cache_manager.
/// This will also help standardize the way of accessing cache in the project.
class FileCachingService {
  DefaultCacheManager defaultCacheManager = DefaultCacheManager();

  /// NOTE: It's recommended to get/store a file with a key. Recommended to use FILENAME generated from the server to get/store the file.

  /// Get a file with given url.
  /// Returns Stream<FileResponse> object to give a reference to the file's status.
  /// If the given url's file is already in the storage. It will be quite instantaneous.
  /// If the given url's file is not in the storage, It will be download using the Internet.
  /// Toggle withProgress will tell the file's downloading progress on or off.
  /// key is the ID of the file, so that you can retrieve the file conveniently.
  Stream<FileResponse> getFileStream(String url, String key, {bool withProgress = true}) {
    return defaultCacheManager.getFileStream(url, withProgress: withProgress, key: key);
  }

  /// Get a File object from current local cache storage.
  /// Only returns AFTER the File is completely downloaded and stored.
  /// /// key is the ID of the file, so that you can retrieve the file conveniently.
  Future<File> getSingleFile(String url, String key) async {
    return defaultCacheManager.getSingleFile(url, key: key);
  }

  /// Get the file from cache.
  /// If the given url's file is not in the storage, It will NOT be downloaded from the Internet.
  Future<FileInfo> getFileFromCache(String key) async {
    return defaultCacheManager.getFileFromCache(key);
  }

  /// Download a File from the Internet with the given url.
  /// Execute this function will auto store the file into the cache automatically.
  Future<FileInfo> downloadFile(String url, String key) async {
    return defaultCacheManager.downloadFile(url, key: key);
  }

  /// Store a File into the cache.
  Future<File> putFile(File file, String url, String key) async {
    return defaultCacheManager.putFile(url, file.readAsBytesSync(), key: key);
  }

  /// Removes a file from the cache storage.
  Future<void> removeFile(String key) async {
    return defaultCacheManager.removeFile(key);
  }

  /// Clears the cache storage.
  Future<void> emptyCache() async {
    return defaultCacheManager.emptyCache();
  }
}
