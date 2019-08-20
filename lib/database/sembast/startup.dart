


import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

//
Future<dynamic> startSembastDatabase() async {
// https://github.com/tekartik/sembast.dart/blob/master/sembast/doc/open.md
// get the application documents directory
  var dir = await getApplicationDocumentsDirectory();
// make sure it exists
  await dir.create(recursive: true);
// build the database path
  var dbPath = dir.path + 'pocketChat.db';
// open the database
  var db = await databaseFactoryIo.openDatabase(dbPath);
  return db;
}

