import 'dart:async';

import 'package:get/get.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/objects/rest/index.dart';
import 'package:snschat_flutter/rest/custom_http_client/custom_http_client.dart';

class MultimediaAPIService {
  EnvironmentGlobalVariables env = Get.find();
  String multimediaAPI = "multimedia";

  CustomHttpClient httpClient = Get.find();

  Future<Multimedia> getSingleMultimedia(String multimediaId) async {
    return Multimedia.fromJson(await httpClient.getRequest("${env.REST_URL}/$multimediaAPI/$multimediaId", showDialog: false, showSnackBar: false));
  }

  /// Get a list of multimedia in one go.
  Future<List<Multimedia>> getMultimediaList(GetMultimediaListRequest getMultimediaListRequest) async {
    List<dynamic> multimediaListRaw = await httpClient.postRequest("${env.REST_URL}/$multimediaAPI/", requestBody: getMultimediaListRequest);
    return multimediaListRaw.map((e) => Multimedia.fromJson(e)).toList();
  }
}
