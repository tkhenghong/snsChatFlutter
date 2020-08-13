import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/exceptions/NetworkExceptions.dart';
import 'package:snschat_flutter/service/index.dart';

import '../RestRequestUtils.dart';

class CustomHttpClient {
  CustomHttpClient._privateConstructor();

  final NetworkService networkService = NetworkService();

  static final CustomHttpClient _instance = CustomHttpClient._privateConstructor();

  factory CustomHttpClient() {
    return _instance;
  }

  Future<dynamic> getRequest(String path, {Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      return handleResponse(await get(path, headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> postRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      return handleResponse(await post(path, body: json.encode(requestBody.toJson()), headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> putRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      return handleResponse(await put(path, body: json.encode(requestBody.toJson()), headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> deleteRequest(String path, {Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = await handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      return handleResponse(await delete(path, headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Future<Map<String, String>> handleHTTPHeaders(Map<String, String> additionalHeaders) async {
    Map<String, String> headers = createAcceptJSONHeader();

    String jwt = await _readJWT();

    if (!isStringEmpty(jwt)) {
      headers.putIfAbsent('Authorization', () => 'Bearer $jwt');
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

    print('CustomHttpClient.dart hasInternetConnection: ' + hasInternetConnection.toString());
    print('CustomHttpClient.dart connectedThroughMobileData: ' + connectedThroughMobileData.toString());
    print('CustomHttpClient.dart connectedThroughWifi: ' + connectedThroughWifi.toString());

    if (!hasInternetConnection) {
      throw ConnectionException(ErrorResponse(), 'No Internet connection.');
    }
  }

  dynamic handleResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 299) {
      if (response.body.isEmpty) {
        return null;
      } else {
        return jsonDecode(response.body);
      }
    } else {
      final ErrorResponse errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));
      if (statusCode >= 400 && statusCode < 500) {
        print('CustomHttpClient.dart if (statusCode >= 400 && statusCode < 500)');
        print('CustomHttpClient.dart errorResponse.toString(): ' + errorResponse.toString());
        ;
        throw ClientErrorException(errorResponse, statusCode.toString());
      } else if (statusCode >= 500 && statusCode < 600) {
        print('CustomHttpClient.dart else if (statusCode >= 500 && statusCode < 600)');
        throw ServerErrorException(errorResponse, statusCode.toString());
      } else {
        print('CustomHttpClient.dart UnknownException');
        throw UnknownException(errorResponse, statusCode.toString());
      }
    }
  }

  void handleError() {
    throw ConnectionException(null, '');
  }
}
