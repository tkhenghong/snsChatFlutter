import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;

String supportEmail = globals.supportEmail;

abstract class ApiException implements Exception {
  ApiException(String message) {
    if (Get.isOverlaysOpen || Get.isBottomSheetOpen || Get.isSnackbarOpen || Get.isDialogOpen) {
      Get.back();
    }

    Get.dialog(
        SimpleDialog(
          title: Text(this.runtimeType.toString()),
          children: [
            Center(
              child: Column(
                children: <Widget>[
                  Text(message),
                  RaisedButton(
                    child: Text('Send error report'),
                    onPressed: () {
                      print('Send Error Report button Pressed.');
                    },
                  ),
                  RaisedButton(
                    child: Text('OK'),
                    onPressed: () {
                      Get.back();
                    },
                  )
                ],
              ),
            )
          ],
        ),
        barrierDismissible: false);
  }
}

class EmptyResultException extends ApiException {
  EmptyResultException(String message) : super(message) {}
}

class ConnectionException extends ApiException {
  ConnectionException(String message) : super(message) {}
}

class ServerErrorException extends ApiException {
  ServerErrorException(String message) : super(message) {}
}

class ClientErrorException extends ApiException {
  ClientErrorException(String message) : super(message) {}
}

class UnknownException extends ApiException {
  UnknownException(String message) : super(message) {}
}
