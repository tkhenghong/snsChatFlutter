import 'package:fluttertoast/fluttertoast.dart';

showToast(String message, Toast duration) {
  Fluttertoast.showToast(msg: message, toastLength: duration);
}