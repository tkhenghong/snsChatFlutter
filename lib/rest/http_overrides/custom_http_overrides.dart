import 'dart:io';

import 'package:flutter/services.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;

class CustomHttpOverrides extends HttpOverrides {
  String ENVIRONMENT = globals.ENVIRONMENT;
  List<String> allowedHost = globals.allowedHosts;

  ByteData byteData;

  CustomHttpOverrides(ByteData byteData) {
    this.byteData = byteData;
  }

  @override
  HttpClient createHttpClient(SecurityContext context) {
    context = new SecurityContext();
    context.setTrustedCertificatesBytes(this.byteData.buffer.asUint8List(), password: 'password');
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        if (allowedHost.contains(host)) {
          return true;
        }
        return false;
      };
  }
}
