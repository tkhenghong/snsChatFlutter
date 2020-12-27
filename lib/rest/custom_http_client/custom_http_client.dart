import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/exceptions/network_exceptions.dart';
import 'package:snschat_flutter/service/index.dart';

import '../rest_request.utils.dart';

class CustomHttpClient {
  CustomHttpClient._privateConstructor();

  final NetworkService networkService = NetworkService();

  static final CustomHttpClient _instance = CustomHttpClient._privateConstructor();

  factory CustomHttpClient() {
    return _instance;
  }

  Future<dynamic> getRequest(String path, {Map<String, String> additionalHeaders, int timeoutSeconds, bool showDialog, bool showSnackBar}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      http.Response response;

      if (!isObjectEmpty(timeoutSeconds)) {
        response = await get(path, headers: headers).timeout(Duration(seconds: timeoutSeconds));
      } else {
        response = await get(path, headers: headers);
      }

      return handleResponse(response, showDialog: showDialog, showSnackBar: showSnackBar);
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> postRequest(String path, {var requestBody, Map<String, String> additionalHeaders, int timeoutSeconds, bool showDialog, bool showSnackBar}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      http.Response response;

      String body = !isObjectEmpty(requestBody) ? json.encode(requestBody.toJson()) : null;

      if (!isObjectEmpty(timeoutSeconds)) {
        response = await post(path, body: body, headers: headers).timeout(Duration(seconds: timeoutSeconds));
      } else {
        response = await post(path, body: body, headers: headers);
      }
      return handleResponse(response, showDialog: showDialog, showSnackBar: showSnackBar);
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> putRequest(String path, {var requestBody, Map<String, String> additionalHeaders, int timeoutSeconds, bool showDialog, bool showSnackBar}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      http.Response response;

      String body = !isObjectEmpty(requestBody) ? json.encode(requestBody.toJson()) : null;

      if (!isObjectEmpty(timeoutSeconds)) {
        response = await put(path, body: body, headers: headers).timeout(Duration(seconds: timeoutSeconds));
      } else {
        response = await put(path, body: body, headers: headers);
      }

      return handleResponse(response, showDialog: showDialog, showSnackBar: showSnackBar);
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> deleteRequest(String path, {Map<String, String> additionalHeaders, int timeoutSeconds, bool showDialog, bool showSnackBar}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      http.Response response;

      if (!isObjectEmpty(timeoutSeconds)) {
        response = await delete(path, headers: headers).timeout(Duration(seconds: timeoutSeconds));
      } else {
        response = await delete(path, headers: headers);
      }

      return handleResponse(response, showDialog: showDialog, showSnackBar: showSnackBar);
    } on SocketException {
      handleError();
    }
  }

  Future<Map<String, String>> handleHTTPHeaders(Map<String, String> additionalHeaders) async {
    Map<String, String> headers = createAcceptJSONHeader();

    String jwt = await _readJWT();

    print('custom_http_client.dart jwt : $jwt');

    if (!isStringEmpty(jwt)) {
      print('if (!jwt.isEmpty)');
      headers.putIfAbsent('Authorization', () => 'Bearer $jwt');
    } else {
      print('if (jwt.isEmpty)');
    }

    if (!isObjectEmpty(additionalHeaders)) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  Future<String> _readJWT() async {
    final FlutterSecureStorage flutterSecureStorage = Get.find();
    return await flutterSecureStorage.read(key: "jwtToken");
  }

  checkNetwork() async {
    await networkService.initConnectivity();
    bool connectedThroughMobileData = networkService.connectedThroughMobileData.value;
    bool connectedThroughWifi = networkService.connectedThroughWifi.value;
    bool hasInternetConnection = networkService.hasInternetConnection.value;

    if (!hasInternetConnection) {
      throw ConnectionException(ErrorResponse(), 'No Internet connection.');
    }
  }

  dynamic handleResponse(http.Response response, {bool showDialog, bool showSnackBar}) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 299) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return json.decode(response.body);
      }
    } else {
      final ErrorResponse errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      if (statusCode >= 400 && statusCode < 500) {
        print('custom_http_client.dart if (statusCode >= 400 && statusCode < 500)');
        print('custom_http_client.dart errorResponse.toString(): ' + errorResponse.toString());
        throw ClientErrorException(errorResponse, statusCode.toString(), showSnackBar, showDialog);
      } else if (statusCode >= 500 && statusCode < 600) {
        print('custom_http_client.dart else if (statusCode >= 500 && statusCode < 600)');
        throw ServerErrorException(errorResponse, statusCode.toString(), showSnackBar, showDialog);
      } else {
        print('custom_http_client.dart UnknownException');
        throw UnknownException(errorResponse, statusCode.toString(), showSnackBar, showDialog);
      }
    }
  }

  void handleError() {
    throw ConnectionException(null, '');
  }
}
