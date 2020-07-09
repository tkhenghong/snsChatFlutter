import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/rest/exceptions/NetworkExceptions.dart';

import '../RestRequestUtils.dart';

class CustomHttpClient {
  CustomHttpClient._privateConstructor();

  static final CustomHttpClient _instance = CustomHttpClient._privateConstructor();

  factory CustomHttpClient() {
    return _instance;
  }

  Future<dynamic> getRequest(String path, {Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    try {
      return handleResponse(await get(path, headers: headers));
    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> postRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    try {
      return handleResponse(await post(path, body: requestBody.toJson(), headers: headers));
    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> putRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    try {
      return handleResponse(await put(path, body: requestBody.toJson(), headers: headers));
    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> deleteRequest(String path, {Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = handleHTTPHeaders(additionalHeaders);
    try {
      return handleResponse(await delete(path, headers: headers));
    } on SocketException {
      throw ConnectionException();
    }
  }

  Map<String, String> handleHTTPHeaders(additionalHeaders) {
    Map<String, String> headers = createAcceptJSONHeader();
    if (!isObjectEmpty(additionalHeaders)) {
      headers.addAll(additionalHeaders);
    }

    return additionalHeaders;
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
      throw ClientErrorException();
    } else if (statusCode >= 500 && statusCode < 600) {
      throw ServerErrorException();
    } else {
      throw UnknownException();
    }
  }
}
