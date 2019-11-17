import 'package:flutter/material.dart';

void showLoading(BuildContext context, String message) {
  Color appBarTextTitleColor = Theme.of(context).appBarTheme.textTheme.title.color;

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
        );
      });
}

void showCenterLoadingIndicator(BuildContext context) {
  Color appBarTextTitleColor = Theme.of(context).appBarTheme.textTheme.title.color;

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(appBarTextTitleColor),
          ),
        );
      });
}
