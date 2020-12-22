import 'package:flutter/material.dart';
import 'package:get/get.dart';


/// To show standard dialog with a title and message and OK button.
void showNotificationDialog(String title, String message) {
  Color whiteColor = Colors.white;

  TextStyle dialogTitleTextStyle = TextStyle(fontWeight: FontWeight.bold, color: whiteColor);

  TextStyle dialogLabelsTextStyle = TextStyle();

  TextStyle dialogButtonsTextStyle = TextStyle(color: whiteColor);

  Get.dialog(Container(
    child: SimpleDialog(
      titlePadding: EdgeInsets.zero,
      titleTextStyle: dialogTitleTextStyle,
      title: AppBar(
        centerTitle: true,
        leadingWidth: 0.0,
        leading: Container(),
        title: Text(title),
      ),
      // contentPadding: EdgeInsets.zero,
      children: [
        Center(
          child: Text(
            message,
            style: dialogLabelsTextStyle,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text(
                'OK',
                style: dialogButtonsTextStyle,
              ),
              onPressed: () {
                Get.back();
              },
            )
          ],
        )
      ],
    ),
  ));
}

/// Simple standard confirmation dialog.
Future<dynamic> showConfirmationDialog({String title, String message, Function onConfirm, Function onCancel}) async {
  Color whiteColor = Colors.white;
  double roundBorderRadius = 10.0;
  ShapeBorder fullRoundedBorder = RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundBorderRadius));
  ShapeBorder topRoundedBorder = RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(roundBorderRadius), topRight: Radius.circular(roundBorderRadius)));

  TextStyle dialogTitleTextStyle = TextStyle(color: whiteColor, fontSize: 18.0);

  TextStyle dialogLabelsTextStyle = TextStyle(height: 1.5);

  TextStyle cancelButtonTextStyle = TextStyle(color: Get.theme.primaryColor);
  TextStyle dialogButtonsTextStyle = TextStyle(color: whiteColor);

  return Get.dialog(SimpleDialog(
    shape: fullRoundedBorder,
    titlePadding: EdgeInsets.zero,
    title: AppBar(
      shape: topRoundedBorder,
      leadingWidth: 0.0,
      elevation: 0.0,
      leading: Container(),
      title: Text(title, style: dialogTitleTextStyle),
      centerTitle: true,
    ),
    contentPadding: EdgeInsets.zero,
    children: [
      // Bottom center a widget in a Column Widget.
      // https://stackoverflow.com/questions/45746636
      Container(
          width: Get.width * 0.95,
          constraints: BoxConstraints(minHeight: 0.0, maxHeight: Get.height * 0.3),
          padding: EdgeInsets.only(top: Get.height * 0.01),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: dialogLabelsTextStyle,
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(bottom: Get.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.width * 0.3,
                          height: Get.height * 0.06,
                          child: FlatButton(
                            shape: fullRoundedBorder,
                            child: Text(
                              'Cancel',
                              style: cancelButtonTextStyle,
                            ),
                            onPressed: () async {
                              onCancel();
                              Get.back();
                            },
                          ),
                        ),
                        Container(
                          width: Get.width * 0.35,
                          height: Get.height * 0.06,
                          child: RaisedButton(
                            shape: fullRoundedBorder,
                            child: Text(
                              'Confirm',
                              style: dialogButtonsTextStyle,
                            ),
                            onPressed: () async {
                              onConfirm();
                              Get.back();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ))
    ],
  ));
}
