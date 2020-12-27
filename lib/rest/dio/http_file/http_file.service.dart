import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as HTTPDio;
import 'package:dio/src/options.dart' as DioOptions;
import 'package:get/get.dart';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/rest/rest_request.utils.dart';

// https://pub.dev/packages/dio
// Get file name: https://medium.com/@codinghive.dev/get-file-name-in-flutter-73acd9bea9b3
class HTTPFileService {
  String REST_URL = globals.REST_URL;

  Dio dio = Get.find();
  FlutterSecureStorage flutterSecureStorage = Get.find();

  Future<HTTPDio.Response<dynamic>> uploadFile(String url, List<File> files,
      {Map<String, String> additionalHeaders,
      int sendTimeoutSeconds,
      int receiveTimeoutSeconds,
      Map<String, dynamic> data,
      Function onSendProgress}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    List<HTTPDio.MultipartFile> multipartFileList = [];

    for (int i = 0; i < files.length; i++) {
      multipartFileList.add(await HTTPDio.MultipartFile.fromFile(files[i].path, filename: path.basename(files[i].path)));
    }

    HTTPDio.FormData formData = HTTPDio.FormData.fromMap({'files': multipartFileList});

    return await dio.post(url,
        data: formData,
        options: DioOptions.Options(
            headers: headers,
            sendTimeout: sendTimeoutSeconds,
            receiveTimeout: receiveTimeoutSeconds));
  }

  /// Download a file using Dio
  /// Example of download a file: https://stackoverflow.com/questions/59616610
  Future<HTTPDio.Response<dynamic>> downloadFile(String url, String savePath, {Function(int, int) onDownloadProgress}) async {
    return await dio.download("$REST_URL/$url", savePath, onReceiveProgress: onDownloadProgress);
  }

  Future<Map<String, String>> handleHTTPHeaders(Map<String, String> additionalHeaders) async {
    Map<String, String> headers = createAcceptJSONHeader();

    String jwt = await _readJWT();

    if (!isObjectEmpty(jwt)) {
      headers.putIfAbsent('Authorization', () => 'Bearer $jwt');
    }

    if (!additionalHeaders.isBlank && additionalHeaders.isNotEmpty) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  Future<String> _readJWT() async {
    return await flutterSecureStorage.read(key: "jwtToken");
  }
}
