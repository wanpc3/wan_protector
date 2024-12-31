import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'table_models/wp_user.dart';

class WPDatabaseHelper {
  static final WPDatabaseHelper instance = WPDatabaseHelper._instance();
  static Database? _database;

  WPDatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'wan_protector.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wp_user (
        userNo INTEGER PRIMARY KEY AUTOINCREMENT,
        email VARCHAR(255) UNIQUE NOT NULL,
        username VARCHAR(255) UNIQUE NOT NULL
      )
    ''');
  }

  Future<int> insertUser(WPUser user) async {
    try {
      final db = await this.db;
      return await db.insert('wp_user', user.toMap());
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  Future<List<WPUser>> getAllUsers() async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query('wp_user');
    return result.map((map) => WPUser.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await this.db;
    db.close();
  }
}