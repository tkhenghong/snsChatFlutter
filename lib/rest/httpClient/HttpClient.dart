import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/rest/exceptions/NetworkExceptions.dart';

import '../RestRequestUtils.dart';

class HttpClient {
  HttpClient._privateConstructor();

  static final HttpClient _instance = HttpClient._privateConstructor();

  factory HttpClient() {
    return _instance;
  }

  Future<dynamic> getRequest(String path) async {
    Response response;

    try {
      response = await get(path);
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
    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> postRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = createAcceptJSONHeader();

    if (!isObjectEmpty(additionalHeaders)) {
      headers.addAll(additionalHeaders);
    }
    Response response;

    try {
      response = await post(path, body: requestBody, headers: headers);
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
    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> putRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = createAcceptJSONHeader();

    if (!isObjectEmpty(additionalHeaders)) {
      headers.addAll(additionalHeaders);
    }
    Response response;

    try {
      response = await put(path, body: requestBody, headers: headers);
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
    } on SocketException {
      throw ConnectionException();
    }
  }

  Future<dynamic> deleteRequest(String path, {var requestBody, Map<String, String> additionalHeaders}) async {
    Map<String, String> headers = createAcceptJSONHeader();

    if (!isObjectEmpty(additionalHeaders)) {
      headers.addAll(additionalHeaders);
    }
    Response response;

    try {
      response = await delete(path, headers: headers);
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
    } on SocketException {
      throw ConnectionException();
    }
  }
}
