import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/service/index.dart';

// Video tutorial: https://www.youtube.com/watch?v=LcaOULash7s
// Make a class to connect your DB file in Android/iOS and make it singleton which can be instantiated only once
class SembastDB {
  // Singleton instance: Declare this class is singleton
  static final SembastDB _singleton = SembastDB._();
  String ENVIRONMENT = globals.ENVIRONMENT;

  // Create private constructor
  SembastDB._();

  // Singleton accessor: When other classes call this class, this is the access they get into
  static SembastDB get instance => _singleton;

  // Completer is a tool that help us to change synchronous code to asynchronous code (Very interesting)
  Completer<Database> _dbOpenCompleter;

  // Get the
  Future<Database> get database async {
    // if _dbOpenCompleter is not null, it will not create a new instance of database object from Sembast
    if (isObjectEmpty(_dbOpenCompleter)) {
      _dbOpenCompleter = Completer();
      _startSembastDatabase();
    }

    // Otherwize, return the value of the function again straight back to the caller.
    return _dbOpenCompleter
        .future; // Returns the last value emitted from the function that linked to this completer instance.
  }

  Future _startSembastDatabase() async {
    // https://github.com/tekartik/sembast.dart/blob/master/sembast/doc/open.md

    var dbPath = "";

    bool storageAccessGranted = false;

    switch (ENVIRONMENT) {
      case "DEVELOPMENT":
        dbPath = 'pocketChat.db';
        storageAccessGranted = true;
        break;
      default:
        CustomFileService fileService = CustomFileService();
        // get the application documents directory
        String path = await fileService.getApplicationDocumentDirectory();
        if (isStringEmpty(path)) {
          storageAccessGranted = false;
        } else {
          // build the database path
          dbPath =
              join(path, 'pocketChat.db'); // join method comes from path.dart
          storageAccessGranted = true;
        }
        break;
    }

    if (storageAccessGranted) {
      // open the database
      var db = await databaseFactoryIo.openDatabase(dbPath);
      _dbOpenCompleter.complete(db);
    } else {
      showToast('Please enable Storage permission first.', Toast.LENGTH_SHORT);
      _dbOpenCompleter.complete(null);
      _dbOpenCompleter = null;
    }
  }
}
