import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Timer {
  final String uuid;
  final String detail;
  final String sePath;
  final String bgmPath;

  final int minutes;
  final int secounds;
  final int restMinutes;
  final int restSecounds;

  Timer(
      {required this.uuid,
      required this.minutes,
      required this.secounds,
      required this.restMinutes,
      required this.restSecounds,
      required this.detail,
      required this.sePath,
      required this.bgmPath});

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'minutes': minutes,
      'secounds': secounds,
      'restMinutes': restMinutes,
      'restSecounds': restSecounds,
      'detail': detail,
      'sePath': sePath,
      'bgmPath': bgmPath,
    };
  }

  static Future<Database> get database async {
    final _database = openDatabase(
      join(await getDatabasesPath(), 'timer_databse.db'),
      onCreate: (db, version) {
        return db.execute("""CREATE TABLE timer(
                uuid TEXT PRIMARY KEY, 
                minutes INTEGER NOT NULL,
                secounds INTEGER NOT NULL,
                restMinutes INTEGER NOT NULL,
                restSecounds INTEGER NOT NULL,
                detail TEXT,
                sePath TEXT,
                bgmPath TEXT
                """);
      },
      version: 1,
    );

    return _database;
  }

  static Future<void> insertTimer(Timer timer) async {
    final db = await database;
    await db.insert('timer', timer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Timer>> getTimers() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('timer');
    return List.generate(maps.length, (index) {
      return Timer(
        uuid: maps[index]['uuid'],
        minutes: maps[index]['minutes'],
        secounds: maps[index]['secounds'],
        restMinutes: maps[index]['restMinutes'],
        restSecounds: maps[index]['restSecounds'],
        detail: maps[index]['detail'],
        sePath: maps[index]['sePath'],
        bgmPath: maps[index]['bgmPath'],
      );
    });
  }

  static Future<void> updateTimer(Timer timer) async {
    final db = await database;
    await db.update(
      'timer',
      timer.toMap(),
      where: 'uuid = ?',
      whereArgs: [timer.uuid],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deleteTimer(String uuid) async {
    final db = await database;
    await db.delete(
      'timer',
      where: "uuuid = ?",
      whereArgs: [uuid],
    );
  }
}
