import 'dart:collection';

Map<String, String> createAcceptJSONHeader() {
  Map<String, String> headers = new HashMap();
  headers['Content-Type'] = "application/json";
  return headers;
}