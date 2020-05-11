import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';
import 'package:snschat_flutter/objects/models/index.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;

class MultimediaAPIService {
  String REST_URL = globals.REST_URL;
  String multimediaAPI = "multimedia";

  Future<Multimedia> addMultimedia(Multimedia multimedia) async {
    String wholeURL = "$REST_URL/$multimediaAPI";
    String multimediaJsonString = json.encode(multimedia.toJson());
    var httpResponse = await http.post(wholeURL,
        body: multimediaJsonString, headers: createAcceptJSONHeader());
    if (httpResponseIsCreated(httpResponse)) {
      String locationString = httpResponse.headers['location'];
      String multimediaId = locationString.replaceAll(wholeURL + "/", "");
      multimedia.id = multimediaId;
      return multimedia;
    }
    return null;
  }

  Future<bool> editMultimedia(Multimedia multimedia) async {
    String multimediaJsonString = json.encode(multimedia.toJson());
    return httpResponseIsOK(await http.put("$REST_URL/$multimediaAPI",
        body: multimediaJsonString, headers: createAcceptJSONHeader()));
  }

  Future<bool> deleteMultimedia(String multimediaId) async {
    var httpResponse =
        await http.delete("$REST_URL/$multimediaAPI/$multimediaId");
    return httpResponseIsOK(httpResponse);
  }

  Future<Multimedia> getSingleMultimedia(String multimediaId) async {
    return getMultimediaBody(
        await http.get("$REST_URL/$multimediaAPI/$multimediaId"));
  }

  Future<Multimedia> getMultimediaOfAUser(String userId) async {
    return getMultimediaBody(
        await http.get("$REST_URL/$multimediaAPI/user/$userId"));
  }

  Future<Multimedia> getMultimediaOfAUserContact(String userContactId) async {
    return getMultimediaBody(
        await http.get("$REST_URL/$multimediaAPI/userContact/$userContactId"));
  }

  Future<Multimedia> getConversationGroupPhotoMultimedia(
      String conversationGroupId) async {
    return getMultimediaBody(await http.get(
        "$REST_URL/$multimediaAPI/conversationGroup/photo/$conversationGroupId"));
  }

  // conversationGroupId is required for find the exact multimedia easier
  Future<Multimedia> getMessageMultimedia(
      String conversationGroupId, String messageId) async {
    return getMultimediaBody(await http.get(
        "$REST_URL/$multimediaAPI/message/$conversationGroupId/$messageId"));
  }

  Future<List<Multimedia>> getAllMultimediaOfAConversationGroup(
      String conversationGroupId) async {
    return getMultimediaListBody(await http.get(
        "$REST_URL/$multimediaAPI/conversationGroup/$conversationGroupId"));
  }

  Multimedia getMultimediaBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      Multimedia multimedia =
          new Multimedia.fromJson(json.decode(httpResponse.body));

      return multimedia;
    }
    return null;
  }

  List<Multimedia> getMultimediaListBody(Response httpResponse) {
    if (httpResponseIsOK(httpResponse)) {
      Iterable list = json.decode(httpResponse.body);
      List<Multimedia> multimediaList =
          list.map((model) => Multimedia.fromJson(model)).toList();

      return multimediaList;
    }
    return null;
  }
}
