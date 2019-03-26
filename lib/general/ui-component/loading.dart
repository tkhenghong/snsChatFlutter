import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new Padding(
                padding: EdgeInsets.all(20.0),
                child: new CircularProgressIndicator(),
              ),
              new Padding(
                padding: EdgeInsets.all(20.0),
                child: new Text("Loading"),
              ),
            ],
          ),
        );
      }
  );

}

void showCenterLoadingIndicator(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
  );
}