import 'dart:io';

import 'package:flutter/services.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;

class MyHttpOverrides extends HttpOverrides {
  String ENVIRONMENT = globals.ENVIRONMENT;
  List<String> allowedHost = globals.allowedHost;

  ByteData byteData;

  MyHttpOverrides(ByteData byteData) {
    this.byteData = byteData;
  }

  @override
  HttpClient createHttpClient(SecurityContext context) {
    context = new SecurityContext();
    context.setTrustedCertificatesBytes(this.byteData.buffer.asUint8List(), password: 'password');
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // TODO: Reissue new certificate for HTTPS connection when go to UAT or production.
        // TODO: Make sure (first name and last name)CN is correct hostname during keystore.jks creation process.
        if (allowedHost.contains(host) || ENVIRONMENT == 'DEVELOPMENT') {
          return true;
        }
        return false;
      };
  }
}
