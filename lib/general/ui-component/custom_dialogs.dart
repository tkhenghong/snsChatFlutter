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

showConfirmationDialog({String title, String description, String value}) {
  TextEditingController textEditingController = new TextEditingController();
  TextStyle cancelButtonTextStyle = TextStyle(color: Get.theme.primaryColor);
  Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: GestureDetector(
          onTap: () => FocusScope.of(Get.context).requestFocus(FocusNode()),
          child: Container(
              height: 300.0,
              width: 300.0,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  titleSpacing: 0.0,
                  title: Row(
                    children: <Widget>[Padding(padding: EdgeInsets.only(left: 10.0)), Text(title)],
                  ),
                ),
                body: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 20.0)),
                          Text(description),
                          TextField(
                            controller: textEditingController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2.0), borderRadius: BorderRadius.circular(10.0)),
                              hintText: value.isEmpty ? 'Enter value here' : value,
                            ),
                          )
                        ],
                      ),
                    )),
                bottomSheet: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(Get.context).pop(value);
                      },
                      child: Text('Cancel', style: cancelButtonTextStyle),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (textEditingController.text.isEmpty) {
                          Navigator.of(Get.context).pop(value);
                        } else {
                          Navigator.of(Get.context).pop(textEditingController.text);
                        }
                      },
                      child: Text(
                        'OK',
                        style: cancelButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
      barrierDismissible: false);
}