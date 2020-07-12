import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoading(String message) {
  BuildContext context = Get.context;
  Color appBarTextTitleColor = Theme.of(context).primaryColor;

  Get.dialog(Dialog(
    child: new Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        new Padding(
          padding: EdgeInsets.all(20.0),
          child: new CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appBarTextTitleColor),
          ),
        ),
        new Padding(
          padding: EdgeInsets.all(20.0),
          child: new Text(message),
        ),
      ],
    ),
  ), barrierDismissible: false);
}

void showCenterLoadingIndicator() {
  Color appBarTextTitleColor = Theme.of(Get.context).appBarTheme.color;

  Get.dialog(Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(appBarTextTitleColor),
    ),
  ), barrierDismissible: false);
}
