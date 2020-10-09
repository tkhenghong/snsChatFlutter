import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:dio/src/options.dart' as DioOptions;
import 'package:get/get.dart';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/rest/rest_request.utils.dart';

// https://pub.dev/packages/dio
// Get file name: https://medium.com/@codinghive.dev/get-file-name-in-flutter-73acd9bea9b3
class HTTPFileService {
  String REST_URL = globals.REST_URL;

  Dio dio = Get.find();
  FlutterSecureStorage flutterSecureStorage = Get.find();

  Future<Response<dynamic>> uploadFile(String url, List<File> files,
      {Map<String, String> additionalHeaders,
      int sendTimeoutSeconds,
      int receiveTimeoutSeconds,
      Map<String, dynamic> data,
      Function onSendProgress}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    List<MultipartFile> multipartFileList = [];

    for (int i = 0; i < files.length; i++) {
      multipartFileList.add(await MultipartFile.fromFile(files[i].path, filename: path.basename(files[i].path)));
    }

    FormData formData = FormData.fromMap({'files': multipartFileList});

    return await dio.post(url,
        data: formData,
        options: DioOptions.Options(
            headers: headers,
            sendTimeout: sendTimeoutSeconds,
            receiveTimeout: receiveTimeoutSeconds));
  }

  Future<Response<dynamic>> downloadFile(String url, String downloadFileName) async {
    return await dio.download("$REST_URL/$url", downloadFileName);
  }

  Future<Map<String, String>> handleHTTPHeaders(Map<String, String> additionalHeaders) async {
    Map<String, String> headers = createAcceptJSONHeader();

    String jwt = await _readJWT();

    if (jwt.isNotEmpty) {
      headers.putIfAbsent('Authorization', () => 'Bearer $jwt');
    }

    if (additionalHeaders.isNotEmpty) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  Future<String> _readJWT() async {
    return await flutterSecureStorage.read(key: "jwtToken");
  }
}
