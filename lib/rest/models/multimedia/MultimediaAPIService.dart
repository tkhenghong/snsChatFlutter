import 'dart:async';

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/rest/customhttpClient/CustomHttpClient.dart';

class MultimediaAPIService {
  String REST_URL = globals.REST_URL;
  String multimediaAPI = "multimedia";

  CustomHttpClient httpClient = new CustomHttpClient();

  Future<Multimedia> addMultimedia(Multimedia multimedia) async {
    return await httpClient.postRequest("$REST_URL/$multimediaAPI", requestBody: multimedia);
  }

  Future<bool> editMultimedia(Multimedia multimedia) async {
    return await httpClient.putRequest("$REST_URL/$multimediaAPI", requestBody: multimedia);
  }

  Future<bool> deleteMultimedia(String multimediaId) async {
    return await httpClient.deleteRequest("$REST_URL/$multimediaAPI/$multimediaId");
  }

  Future<Multimedia> getSingleMultimedia(String multimediaId) async {
    return await httpClient.getRequest("$REST_URL/$multimediaAPI/$multimediaId");
  }

  Future<Multimedia> getMultimediaOfAUser(String userId) async {
    return await httpClient.getRequest("$REST_URL/$multimediaAPI/user/$userId");
  }

  Future<Multimedia> getMultimediaOfAUserContact(String userContactId) async {
    return await httpClient.getRequest("$REST_URL/$multimediaAPI/userContact/$userContactId");
  }

  Future<Multimedia> getConversationGroupPhotoMultimedia(String conversationGroupId) async {
    return await httpClient.getRequest("$REST_URL/$multimediaAPI/conversationGroup/photo/$conversationGroupId");
  }

  // conversationGroupId is required for find the exact multimedia easier
  Future<Multimedia> getMessageMultimedia(String conversationGroupId, String messageId) async {
    return await httpClient.getRequest("$REST_URL/$multimediaAPI/message/$conversationGroupId/$messageId");
  }

  Future<List<Multimedia>> getAllMultimediaOfAConversationGroup(String conversationGroupId) async {
    return await httpClient.getRequest("$REST_URL/$multimediaAPI/conversationGroup/$conversationGroupId");
  }
}
