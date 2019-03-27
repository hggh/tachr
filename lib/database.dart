
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<String> getDatabasePath() async {
  var dbPath = join(await getDatabasesPath(), 'tachr.db');

  if (!await Directory(dirname(dbPath)).exists()) {
      await Directory(dirname(dbPath)).create(recursive: true);
  }
  return dbPath;
}

Future<Database> dbOpen() async {
  String dbPath = await getDatabasePath();

  return await openDatabase(dbPath,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
          create table rides (
            id integer primary key autoincrement, 
            rideTimeSeconds integer not null,
            kilometers integer not null,
            maxSpeed integer not null,
            rideTime integer not null
          )
        ''');
    },
  );

}