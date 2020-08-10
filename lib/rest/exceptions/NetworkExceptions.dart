import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';

String supportEmail = globals.supportEmail;

abstract class ApiException implements Exception {
  ApiException(ErrorResponse errorResponse, {String errorCode, bool showDialog, bool showSnackBar}) {
    if (Get.isOverlaysOpen || Get.isBottomSheetOpen || Get.isSnackbarOpen || Get.isDialogOpen) {
      Get.back();
    }

    String messageTitle = !isObjectEmpty(errorResponse) ? errorResponse.exceptionName : this.runtimeType.toString();
    String messageContent = !isObjectEmpty(errorResponse) && !isStringEmpty(errorResponse.message) ? errorResponse.message : '';
    String trace = !isObjectEmpty(errorResponse) ? errorResponse.trace : 'No traces available.';

    if (!isObjectEmpty(showDialog) && showDialog) {
      Get.dialog(
          SimpleDialog(
            title: Center(
              child: Text(messageTitle),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05),
                child: Column(
                  children: <Widget>[
                    wordSection(errorCode, messageContent, trace),
                    minorSpacing(),
                    sendErrorReportButton(),
                    okButton(),
                  ],
                ),
              )
            ],
          ),
          barrierDismissible: false,
          useRootNavigator: true);
    }

    if (!isObjectEmpty(showSnackBar) && showSnackBar) {
      Get.snackbar(messageTitle, messageContent, snackPosition: SnackPosition.BOTTOM, isDismissible: false, mainButton: sendErrorReportButton());
    }
  }

  Widget wordSection(String errorCode, String messageContent, String trace) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[Text('Error code: ', style: TextStyle(fontWeight: FontWeight.bold)), Text(errorCode)],
        ),
        minorSpacing(),
        Text('Description: ', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(messageContent, softWrap: true),
        minorSpacing(),
        ExpandablePanel(
          header: Text('Details: '),
          collapsed: Text(
            trace,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          expanded: Text(trace, softWrap: true, style: TextStyle(fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }

  Widget minorSpacing() {
    return SizedBox(
      height: Get.height * 0.01,
    );
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
  EmptyResultException(ErrorResponse errorResponse, [String errorCode]) : super(errorResponse, errorCode: errorCode, showSnackBar: true) {}
}

class ConnectionException extends ApiException {
  ConnectionException(ErrorResponse errorResponse, [String errorCode]) : super(errorResponse, errorCode: errorCode, showDialog: true) {}
}

class ServerErrorException extends ApiException {
  ServerErrorException(ErrorResponse errorResponse, [String errorCode]) : super(errorResponse, errorCode: errorCode, showDialog: true) {}
}

class ClientErrorException extends ApiException {
  ClientErrorException(ErrorResponse errorResponse, [String errorCode]) : super(errorResponse, errorCode: errorCode, showDialog: true) {}
}

class UnknownException extends ApiException {
  UnknownException(ErrorResponse errorResponse, [String errorCode]) : super(errorResponse, errorCode: errorCode, showDialog: true) {}
}
