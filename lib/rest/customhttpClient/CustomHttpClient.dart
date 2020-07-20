import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/rest/exceptions/NetworkExceptions.dart';
import 'package:snschat_flutter/service/index.dart';

import '../RestRequestUtils.dart';

class CustomHttpClient {
  CustomHttpClient._privateConstructor();

  static String ENVIRONMENT = globals.ENVIRONMENT;

  final HttpClient httpClient = HttpClient()
    ..badCertificateCallback = ((X509Certificate cert, String host, int port) {
      if (ENVIRONMENT == 'DEVELOPMENT') {
        return true;
      }
      return false;
    });

  final NetworkService networkService = NetworkService();

  static final CustomHttpClient _instance = CustomHttpClient._privateConstructor();

  factory CustomHttpClient() {
    return _instance;
  }

  Future<dynamic> getRequest(String path, {Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    print('CustomHTTPClient getRequest()');
    try {
      await checkNetwork();
      print('BEFORE getRequest()');
      return handleResponse(await get(path, headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> postRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      return handleResponse(await post(path, body: requestBody.toJson(), headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> putRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      return handleResponse(await put(path, body: requestBody.toJson(), headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Future<dynamic> deleteRequest(String path, {Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    try {
      await checkNetwork();
      return handleResponse(await delete(path, headers: headers));
    } on SocketException {
      handleError();
    }
  }

  Map<String, String> handleHTTPHeaders(additionalHeaders) {
    Map<String, String> headers = createAcceptJSONHeader();
    if (!isObjectEmpty(additionalHeaders)) {
      headers.addAll(additionalHeaders);
    }

    return additionalHeaders;
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
      throw ConnectionException('No Internet connection.');
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
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ClientErrorException('Some invalid request of the client');
    } else if (statusCode >= 500 && statusCode < 600) {
      throw ServerErrorException('Server error exception');
    } else {
      throw UnknownException('Unknown exception');
    }
  }

  void handleError() {
    throw ConnectionException('Network error.');
  }
}
