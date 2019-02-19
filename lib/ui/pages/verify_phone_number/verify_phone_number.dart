import 'package:flutter/material.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new VerifyPhoneNumberState();
  }

}

class VerifyPhoneNumberState extends State<VerifyPhoneNumberPage> {
  @override
  Widget build(BuildContext context) {
    String phoneNo = "+6012 309 6127";
    // TODO: implement build
    return  new Scaffold(
      appBar: new AppBar(
        title: new Text('Verify '+phoneNo),
        centerTitle: true,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Privacy Notice")
        ],
      ),
    );
  }

}