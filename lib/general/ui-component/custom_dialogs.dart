import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogs {
  final String title;
  final String description;
  final String value;

  Color themePrimaryColor;
  TextStyle textStyle;

  CustomDialogs({this.title, this.description, this.value});

  TextEditingController textEditingController;

  showConfirmationDialog() {
    textEditingController = new TextEditingController();
    themePrimaryColor = Theme.of(Get.context).textTheme.title.color;
    textStyle = TextStyle(color: themePrimaryColor);
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
                            hintText: value.isEmpty ? "Enter value here" : value,
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
                        child: Text("Cancel", style: textStyle),
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
                          "OK",
                          style: textStyle,
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        barrierDismissible: false);
  }
}
