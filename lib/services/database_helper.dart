// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//   static Database? _database;

//   DatabaseHelper._privateConstructor();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'domino_score.db');
//     return await openDatabase(path, version: 1, onCreate: _onCreate);
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE scores(
//         id INTEGER PRIMARY KEY,
//         team1 TEXT,
//         team2 TEXT,
//         scoreTeam1 INTEGER NOT NULL,
//         scoreTeam2 INTEGER NOT NULL,
//         isWiner BOOLEAN
//       )
//     ''');
//   }
// }
