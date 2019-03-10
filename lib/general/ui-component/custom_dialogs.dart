import 'package:flutter/material.dart';

class CustomDialogs {
  final String title;
  final String description;
  final String value;
  final BuildContext context;

  CustomDialogs({this.context, this.title, this.description, this.value});

  TextEditingController textEditingController;

  showConfirmationDialog() {
    textEditingController = new TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
                  height: 300.0,
                  width: 300.0,
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      title: Row(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Text(title)
                        ],
                      ),
                    ),
                    body: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Text(description),
                          TextField(
                            controller: textEditingController,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              hintText:
                                  value.isEmpty ? "Enter value here" : value,
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
                            print("Clicked");
                            Navigator.of(context).pop(value);
                          },
                          child: Text("Cancel"),
                        ),
                        FlatButton(
                          onPressed: () {
                            print("Clicked");
                            print("value: " + value);
                            print(
                                "The value is: " + textEditingController.text);
                            if (textEditingController.text == "") {
                              // If value is empty
                              Navigator.of(context).pop(value);
                            } else {
                              Navigator.of(context)
                                  .pop(textEditingController.text);
                            }
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
