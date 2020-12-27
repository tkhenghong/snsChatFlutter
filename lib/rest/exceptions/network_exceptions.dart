import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';

String supportEmail = globals.supportEmail;

abstract class ApiException implements Exception {
  ErrorResponse errorResponse;

  ApiException(ErrorResponse errorResponse, {String errorCode, bool showDialog = false, bool showSnackBar = false}) {
    this.errorResponse = errorResponse;

    if (Get.isOverlaysOpen || Get.isBottomSheetOpen || Get.isSnackbarOpen || Get.isDialogOpen) {
      Get.back();
    }

    bool errorResponseIsNull = isObjectEmpty(errorResponse);
    bool errorResponseExceptionNameIsBlank = isStringEmpty(errorResponse.exceptionName);
    bool errorResponseMessageIsBlank = isStringEmpty(errorResponse.message);
    bool errorResponseTraceIsBlank = isStringEmpty(errorResponse.trace);

    String messageTitle = !errorResponseIsNull && !errorResponseExceptionNameIsBlank ? errorResponse.exceptionName : this.runtimeType.toString();
    String messageContent = !errorResponseIsNull && !errorResponseMessageIsBlank ? errorResponse.message : '-';
    String trace = !errorResponseIsNull && !errorResponseTraceIsBlank ? errorResponse.trace : null;

    if (!isObjectEmpty(showDialog) && showDialog) {
      showMessageDialog(messageTitle, messageContent, errorCode, trace);
    }

    if (!isObjectEmpty(showSnackBar) && showSnackBar) {
      showSnackbar(messageTitle, messageContent);
    }
  }

  showSnackbar(String messageTitle, String messageContent) {
    Get.snackbar(messageTitle, messageContent, snackPosition: SnackPosition.BOTTOM, isDismissible: false, mainButton: okButton());
  }

  showMessageDialog(String messageTitle, String messageContent, String errorCode, String trace) {
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

  Widget wordSection(String errorCode, String messageContent, String trace) {
    bool messageContentIsBlank = isStringEmpty(messageContent);
    bool tracetIsBlank = isStringEmpty(trace);


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[Text('Error code: ', style: TextStyle(fontWeight: FontWeight.bold)), Text(errorCode)],
        ),
        minorSpacing(),
        messageContentIsBlank ? Text('Description: ', style: TextStyle(fontWeight: FontWeight.bold)) : Container(),
        messageContentIsBlank ? Text(messageContent, softWrap: true) : Container(),
        minorSpacing(),
        !tracetIsBlank
            ? ExpandablePanel(
                header: Text('Details: '),
                collapsed: Text(
                  trace,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                expanded: !tracetIsBlank ? Text(trace, softWrap: true, style: TextStyle(fontStyle: FontStyle.italic)) : Container(),
              )
            : Container(),
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
  EmptyResultException(ErrorResponse errorResponse, [String errorCode, bool showSnackBar, bool showDialog])
      : super(errorResponse, errorCode: errorCode, showDialog: isObjectEmpty(showDialog) ? false : showDialog, showSnackBar: isObjectEmpty(showSnackBar) ? true : showSnackBar);
}

class ConnectionException extends ApiException {
  ConnectionException(ErrorResponse errorResponse, [String errorCode, bool showSnackBar, bool showDialog])
      : super(errorResponse, errorCode: errorCode, showDialog: isObjectEmpty(showDialog) ? true : showDialog, showSnackBar: isObjectEmpty(showSnackBar) ? false : showSnackBar);
}

class ServerErrorException extends ApiException {
  ServerErrorException(ErrorResponse errorResponse, [String errorCode, bool showSnackBar, bool showDialog])
      : super(errorResponse, errorCode: errorCode, showDialog: isObjectEmpty(showDialog) ? true : showDialog, showSnackBar: isObjectEmpty(showSnackBar) ? false : showSnackBar);
}

class ClientErrorException extends ApiException {
  ClientErrorException(ErrorResponse errorResponse, [String errorCode, bool showSnackBar, bool showDialog])
      : super(errorResponse, errorCode: errorCode, showDialog: isObjectEmpty(showDialog) ? true : showDialog, showSnackBar: isObjectEmpty(showSnackBar) ? false : showSnackBar);
}

class UnknownException extends ApiException {
  UnknownException(ErrorResponse errorResponse, [String errorCode, bool showSnackBar, bool showDialog])
      : super(errorResponse, errorCode: errorCode, showDialog: isObjectEmpty(showDialog) ? true : showDialog, showSnackBar: isObjectEmpty(showSnackBar) ? false : showSnackBar);
}

class NetworkTimeoutException {
  NetworkTimeoutException(String messageTitle, String messageContent) {
    showSnackbar(messageTitle, messageContent);
  }

  showSnackbar(String messageTitle, String messageContent) {
    Get.snackbar(messageTitle, messageContent, snackPosition: SnackPosition.TOP, isDismissible: true, mainButton: okButton());
  }

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Get.back();
        },
        child: Text('OK'));
  }
}
