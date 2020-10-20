import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class MultimediaAPIService {
  String REST_URL = globals.REST_URL;
  String multimediaAPI = "multimedia";

  CustomHttpClient httpClient = Get.find();

  Future<Multimedia> getSingleMultimedia(String multimediaId) async {
    return Multimedia.fromJson(await httpClient.getRequest("$REST_URL/$multimediaAPI/$multimediaId"));
  }
}
