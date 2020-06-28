import 'package:http/http.dart';

bool httpResponseIsOK(Response httpResponse) {
  if (httpResponse.statusCode == 200) {
    return true;
  } else {
    print("Request failed with status: ${httpResponse.statusCode}.");
    return false;
  }
}

bool httpResponseIsCreated(Response httpResponse) {
  if (httpResponse.statusCode == 201) {
    return true;
  } else {
    print("Request failed with status: ${httpResponse.statusCode}.");
    return false;
  }
}
