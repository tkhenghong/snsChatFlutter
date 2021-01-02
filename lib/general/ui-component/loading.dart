import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A general loading full screen widget to show loading.
Widget showLoading() {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          width: Get.width * 0.05,
        ),
        Text('Loading...'),
      ],
    ),
  );
}

/// A dialog using GetX to show dialog of loading with a text message.
void showLoadingDialog(String message) {
  if(Get.isDialogOpen) {
    Get.back();
  }
  Get.dialog(
      Dialog(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(message),
            ),
          ],
        ),
      ),
      barrierDismissible: false);
}

/// A dialog using GetX to show dialog of loading with a CircularProgressIndicator.
void showCenterLoadingIndicatorDialog() {
  Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false);
}
