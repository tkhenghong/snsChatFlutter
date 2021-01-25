import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';

class CustomHttpOverrides extends HttpOverrides {
  EnvironmentGlobalVariables env = Get.find();

  ByteData byteData;

  CustomHttpOverrides(ByteData byteData) {
    this.byteData = byteData;
  }

  @override
  HttpClient createHttpClient(SecurityContext context) {
    context = new SecurityContext();
    context.setTrustedCertificatesBytes(this.byteData.buffer.asUint8List(), password: 'password'); // If your cert has password (Eg. .p12 files), you may type password as optional parameter.
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        if (env.allowedHosts.contains(host)) {
          return true;
        }
        return false;
      };
  }
}
