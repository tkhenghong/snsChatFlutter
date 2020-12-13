import 'package:fluttertoast/fluttertoast.dart';


showToast(String message, Toast duration, {ToastGravity toastGravity}) {
  Fluttertoast.showToast(msg: message, toastLength: duration, gravity: toastGravity);
}
