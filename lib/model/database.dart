import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB(true);
    return _database;
  }

  initDB(bool todoList) async {
    String path = join(await getDatabasesPath(), 'levels_database.db');
    print(path);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
//      await db.execute(
//          'CREATE TABLE morning(id INTEGER PRIMARY KEY AUTOINCREMENT, day INTEGER, grateful TEXT, excited TEXT, month INTEGER, weekday INTEGER, year INTEGER, affirmation TEXT, time TEXT)');
      await db.execute(
          'CREATE TABLE level(id INTEGER PRIMARY KEY AUTOINCREMENT, level INTEGER, category TEXT, unlocked INTEGER, progress INTEGER)');
//      await db.execute(
//          'CREATE TABLE pV(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, locked INTEGER,)');
//          await db.execute(
//              'CREATE TABLE day(id INTEGER PRIMARY KEY AUTOINCREMENT, day INTEGER, improve TEXT, bestMoment TEXT, grateful TEXT, energy INTEGER, morningFeeling INTEGER, sleepQuality INTEGER, affirmation TEXT, excited TEXT, mood INTEGER, productivity INTEGER, month INTEGER, weekday INTEGER, year INTEGER, time TEXT, morningIs INTEGER, eveningIs INTEGER)');
    });
  }

//  insertMorning(Morning day) async {
//    final Database db = await database;
//    var res = await db.insert('morning', day.toMap(),
//        conflictAlgorithm: ConflictAlgorithm.replace);
//    return res;
//  }

  insertLevel(Level level) async {
    final Database db = await database;
    var res = await db.insert('level', level.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  updateLevel(Level level) async {
    // Get a reference to the database.
    final db = await database;
    // Update the given Dog.
    await db.update(
      'level',
      level.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [level.id],
    );
  }

  Future<List<Level>> retrieveAllLevels() async {
    // Get a reference to the database.
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('level');
    var res = List.generate(maps.length, (i) {
      return Level.fromMap(maps[i]);
    });
    return maps.isNotEmpty ? res : null;
  }

  Future<Level> getLevel(Category category, int diff) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('level');
    var resFirst = List.generate(maps.length, (i) {
      return Level.fromMap(maps[i]);
    });
    var res = resFirst.firstWhere(
        (level) => level.category == category && level.level == diff);
    print('res $res');

    return res;
  }

  Future<int> score(Category category, int diff) async {
    var res = await this.getLevel(category, diff);
    return res.progress;
  }


}
