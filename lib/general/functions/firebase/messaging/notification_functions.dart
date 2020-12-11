
/// This happens when your app is in background(exited/stopped), when a notification comes, the app will process something here.
/// The method must be placed not under any classes(TOP-LEVEL function).
/// https://stackoverflow.com/questions/59507775
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}