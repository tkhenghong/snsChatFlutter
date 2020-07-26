import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DownloadFileService {

  Dio dio;

  DownloadFileService() {
    dio = Get.find();
  }
}