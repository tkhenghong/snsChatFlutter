import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:snschat_flutter/environments/development/variables.dart' as globals;
import 'package:snschat_flutter/general/index.dart';
import 'package:snschat_flutter/service/index.dart';

/// Sembast Plugin: https://pub.dev/packages/sembast
/// Sembast DB is a NoSQL, persistent store database.
/// It's records are stored into a file. All records are loaded into the memory when opened.
/// Changes are appended right away and the DB file is automatically compacted when needed. The meaning is explained in following sentences:
/// Sembast DB is read easily but not optimized for SIZE.
/// Each data is appended lazily to the file for best performance. (Means the system will keep saving the record without deleting the the previous record, even for delete operation)
/// The SembastDB system has rules of removing those records, if the record has:
/// 1. Written at least 6 times in the file.
/// 2. The record has 20% or more content to be removed.
/// There may be many same records in the file, but when running the app and DB file is loaded into memory, it will be shown as ONE record only.***
/// Explanation reference: https://github.com/tekartik/sembast.dart/blob/master/sembast/doc/storage_format.md


/// Compared with Hive(another NoSQL solution).
/// 1. Hive has good reads and writes(much faster than SQLite), and have some benchmarks to prove in typically situations.
/// 2. It is key-value based DB solution. Simple to set up. Easy to write CRUD of the domain objects.
/// 3. It has much higher rating (thumbs up) in pub.dev (1.16k as of 03012021) compared to Sembast (282 as of 03012021).
/// 4. It can save data on disk with a SHA-256 encryption key.
/// 5. But, it has limited support for querying and sorting, the user have to write implementations for them. The developer explained filtering and sorting is much faster in Dart.

/// The developer has choose Sembast because:
/// It has more similar implementations like MongoDB in the backend(more document based)
/// The developer thinks the performance of Sembast is very similar to Hive as they both have similar implementations in their explanations on how they store and load their data from disk to memory.
/// Sembast has better querying and sorting system compared to Hive as it has Filter object that covers the essential functions that the developer needs.
/// Sembast can not only uses SHA-256 encryption on it's database, but other types of encryption as well, refer to https://github.com/tekartik/sembast.dart/blob/master/sembast/doc/codec.md.

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

    // Otherwise, return the value of the function again straight back to the caller.
    return _dbOpenCompleter.future; // Returns the last value emitted from the function that linked to this completer instance.
  }

  Future _startSembastDatabase() async {
    // https://github.com/tekartik/sembast.dart/blob/master/sembast/doc/open.md

    var dbPath = "";

    bool storageAccessGranted = false;

    switch (ENVIRONMENT) {
      case "LOCAL_COMPUTER":
        dbPath = 'pocketChat.db';
        storageAccessGranted = true;
        break;
      case "DEVELOPMENT":
      default:
        CustomFileService fileService = Get.find();
        // get the application documents directory
        String path = await fileService.setBaseDirectory();
        if (path.isEmpty) {
          storageAccessGranted = false;
        } else {
          // build the database path
          dbPath = join(path, 'pocketChat.db'); // join method comes from path.dart
          print('SembastDB.dart dbPath: $dbPath');
          storageAccessGranted = true;
        }
        break;
    }

    if (storageAccessGranted) {
      // open the database
      DatabaseFactory dbFactory = databaseFactoryIo;
      Database db = await dbFactory.openDatabase(dbPath);
      _dbOpenCompleter.complete(db);
    } else {
      showToast('Please enable Storage permission first.', Toast.LENGTH_SHORT);
      _dbOpenCompleter.complete(null);
      _dbOpenCompleter = null;
    }
  }
}
