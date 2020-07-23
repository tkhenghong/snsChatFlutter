import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;

String supportEmail = globals.supportEmail;

abstract class ApiException implements Exception {
  ApiException(String message, {String errorCode, bool showDialog, bool showSnackBar}) {
    if (Get.isOverlaysOpen || Get.isBottomSheetOpen || Get.isSnackbarOpen || Get.isDialogOpen) {
      Get.back();
    }

    if (showDialog) {
      Get.dialog(
          SimpleDialog(
            title: Center(
              child: Text(this.runtimeType.toString()),
            ),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.01, right: Get.width * 0.01),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text('Error code: $errorCode'),
                        Text('The text below are the response from the server: '),
                        Text(message),
                        sendErrorReportButton(),
                        okButton(),
                      ],
                    ),
                  ))
            ],
          ),
          barrierDismissible: false,
          useRootNavigator: true);
    }

    if (showSnackBar) {
      Get.snackbar(this.runtimeType.toString(), message, snackPosition: SnackPosition.BOTTOM, isDismissible: true, mainButton: sendErrorReportButton());
    }
  }

  Widget sendErrorReportButton() {
    return FlatButton(
      onPressed: () {
        print('Send Error Report button Pressed.');
      },
      child: Text('Send error report'),
    );
  }

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Get.back();
        },
        child: Text('OK'));
  }
}

class EmptyResultException extends ApiException {
  EmptyResultException(String message, [String errorCode]) : super(message, errorCode: errorCode, showSnackBar: true) {}
}

class ConnectionException extends ApiException {
  ConnectionException(String message, [String errorCode]) : super(message, errorCode: errorCode, showDialog: true) {}
}

class ServerErrorException extends ApiException {
  ServerErrorException(String message, [String errorCode]) : super(message, errorCode: errorCode, showDialog: true) {}
}

class ClientErrorException extends ApiException {
  ClientErrorException(String message, [String errorCode]) : super(message, errorCode: errorCode, showDialog: true) {}
}

class UnknownException extends ApiException {
  UnknownException(String message, [String errorCode]) : super(message, errorCode: errorCode, showDialog: true) {}
}
