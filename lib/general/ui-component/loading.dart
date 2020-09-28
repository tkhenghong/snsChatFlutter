import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoading(String message) {
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

void showCenterLoadingIndicator() {
  Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false);
}
