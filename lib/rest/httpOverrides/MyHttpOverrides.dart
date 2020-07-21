import 'dart:io';

import 'package:flutter/services.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/functions/index.dart';

class MyHttpOverrides extends HttpOverrides {
  static String ENVIRONMENT = globals.ENVIRONMENT;

  ByteData byteData;

  MyHttpOverrides(ByteData byteData) {
    this.byteData = byteData;
  }

  @override
  HttpClient createHttpClient(SecurityContext context) {
    context = new SecurityContext();
    print('this.byteData.toString(): ' + this.byteData.toString());
    print('this.byteData.buffer.asUint8List().toString(): ' + this.byteData.buffer.asUint8List().toString());
    context.setTrustedCertificatesBytes(this.byteData.buffer.asUint8List(), password: 'password');
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        print('cert.subject: ' + cert.subject);
        print('cert.endValidity.toIso8601String(): ' + cert.endValidity.toIso8601String());
        print('cert.startValidity.toIso8601String(): ' + cert.startValidity.toIso8601String());
        print('cert.issuer: ' + cert.issuer);
        print('cert.pem: ' + cert.pem);
        print('cert.sha1.length.toString(): ' + cert.sha1.length.toString());
        print('cert.sha1.toString(): ' + cert.sha1.toString());
        print('cert.der.length.toString(): ' + cert.der.length.toString());
        print('cert.der.toString(): ' + cert.der.toString());
        if (ENVIRONMENT == 'DEVELOPMENT') {
          return true;
        }
        return false;
      };
  }
}
