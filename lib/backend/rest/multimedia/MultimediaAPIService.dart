import 'dart:async';

import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/objects/multimedia/multimedia.dart';

import '../RestResponseUtils.dart';

class MultimediaAPIService {
  String REST_URL = globals.REST_URL;

  Future<String> addMultimedia(Multimedia multimedia) async {
    var httpResponse =
        await http.post(REST_URL + "/multimedia", body: multimedia);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      // TODO: Find the new id returned by the server
      var newMultimediaId = jsonResponse['id'];
      print("newMultimediaId: " + newMultimediaId);
      multimedia.id = newMultimediaId;
      return multimedia.id;
    }
    Fluttertoast.showToast(
        msg: 'Unable to create a new multimedia.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }

  Future<bool> editMultimedia(Multimedia multimedia) async {
    var httpResponse =
        await http.put(REST_URL + "/multimedia", body: multimedia);
    return httpResponseIsOK(httpResponse);
  }

  deleteMultimedia(Multimedia multimedia) async {
    var httpResponse =
        await http.delete(REST_URL + "/multimedia" + multimedia.id);
    return httpResponseIsOK(httpResponse);
  }

  Future<List<Multimedia>> getMultimediaOfAUser(String userId) async {
    var httpResponse = await http.get(REST_URL + "/multimedia/user/" + userId);

    if (httpResponseIsOK(httpResponse)) {
      var jsonResponse = convert.jsonDecode(httpResponse.body);
      List<Multimedia> multimediaList = convert.jsonDecode(jsonResponse);
      print("multimediaList.length: " + multimediaList.length.toString());

      return multimediaList;
    }
    Fluttertoast.showToast(
        msg: 'Unable to get multimediaList for this user.Please try again.',
        toastLength: Toast.LENGTH_SHORT);
    return null;
  }
}
