import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:snschat_flutter/environments/development/variables.dart'
    as globals;
import 'package:snschat_flutter/service/permissions/PermissionService.dart';

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
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _startSembastDatabase();
    }

    // Otherwize, return the value of the function again straight back to the caller.
    return _dbOpenCompleter
        .future; // Returns the last value emitted from the function that linked to this completer instance.
  }

  Future _startSembastDatabase() async {
    print("SembastDB.dart _startSembastDatabase()");
    // https://github.com/tekartik/sembast.dart/blob/master/sembast/doc/open.md

    var dbPath = "";
    switch (ENVIRONMENT) {
      case "DEVELOPMENT":
        print("CASE DEVELOPMENT.");
        dbPath = 'pocketChat.db';
        break;
      default:
        // get the application documents directory
        var dir = await getApplicationDocumentsDirectory();
        // make sure it exists
        await dir.create(recursive: true);
        // build the database path
        dbPath =
            join(dir.path, 'pocketChat.db'); // join method comes from path.dart
        break;
    }

    // TODO: Reject all localDB queries if cannot open the database
    // open the database
    PermissionService permissionService = PermissionService();
    bool storageAccessGranted =
        await permissionService.requestStoragePermission();
    if (storageAccessGranted) {
      var db = await databaseFactoryIo.openDatabase(dbPath);
      _dbOpenCompleter.complete(db);
    } else {
      _dbOpenCompleter.complete(null);
    }
  }
}
