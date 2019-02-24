import 'package:flutter/material.dart';

class ScanQrCodePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new ScanQrCodePageState();
  }
}

class ScanQrCodePageState extends State<ScanQrCodePage> {
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Scan QR Code page")
        ],
      ),
    );
  }
}