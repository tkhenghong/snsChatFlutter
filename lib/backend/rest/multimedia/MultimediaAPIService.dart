import 'dart:async';

import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

import '../RestRequestUtils.dart';
import '../RestResponseUtils.dart';

class MultimediaAPIService {
  String REST_URL = globals.REST_URL;

  Future<Multimedia> addMultimedia(Multimedia multimedia) async {
    String wholeURL = REST_URL + "/multimedia";
    String multimediaJsonString = json.encode(multimedia.toJson());
    var httpResponse = await http.post(REST_URL + "/multimedia", body: multimediaJsonString, headers: createAcceptJSONHeader());
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
    var httpResponse = await http.put(REST_URL + "/multimedia", body: multimediaJsonString, headers: createAcceptJSONHeader());
    return httpResponseIsOK(httpResponse);
  }

  Future<bool> deleteMultimedia(String multimediaId) async {
    var httpResponse = await http.delete(REST_URL + "/multimedia/" + multimediaId);
    return httpResponseIsOK(httpResponse);
  }

  Future<Multimedia> getSingleMultimedia(String multimediaId) async {
    var httpResponse = await http.get(REST_URL + "/multimedia/" + multimediaId);
    if (httpResponseIsOK(httpResponse)) {
      Multimedia multimedia = new Multimedia.fromJson(json.decode(httpResponse.body));
      return multimedia;
    }
    return null;
  }

  Future<Multimedia> getMultimediaOfAUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/multimedia/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      Multimedia multimedia = new Multimedia.fromJson(json.decode(httpResponse.body));

      return multimedia;
    }
    return null;
  }

  Future<List<Multimedia>> getMultimediaOfAConversationGroup(String conversationGroupId) async {
    var httpResponse = await http.get(REST_URL + "/multimedia/conversationGroup/" + conversationGroupId);
    if (httpResponseIsOK(httpResponse)) {
      Iterable list = json.decode(httpResponse.body);
      List<Multimedia> multimediaList = list.map((model) => Multimedia.fromJson(model)).toList();

      return multimediaList;
    }
    return null;
  }

  Future<Multimedia> getMultimediaOfAUserContact(String userContactId) async {
    var httpResponse = await http.get(REST_URL + "/multimedia/userContact/" + userContactId);
    if (httpResponseIsOK(httpResponse)) {
      Multimedia multimedia = new Multimedia.fromJson(json.decode(httpResponse.body));

      return multimedia;
    }
    return null;
  }
}
