import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'table_models/master_pswd.dart';
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

    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop the old table and create a new one
      await db.execute('DROP TABLE IF EXISTS wp_user');
      await db.execute('''
        CREATE TABLE wp_user (
          user_no INTEGER PRIMARY KEY AUTOINCREMENT,
          email VARCHAR(255) UNIQUE NOT NULL
        )
      ''');
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wp_user (
        user_no INTEGER PRIMARY KEY AUTOINCREMENT,
        email VARCHAR(255) UNIQUE NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE master_pswd (
        master_pswd_no INTEGER PRIMARY KEY AUTOINCREMENT,
        master_pswd_text TEXT NOT NULL,
        user_no INTEGER NOT NULL,
        FOREIGN KEY (user_no) REFERENCES wp_user (user_no)
      )
    ''');
  }

  //Insert User information. Relation: one-to-one
  Future<int> insertUser(WPUser user) async {
    try {
      final db = await this.db;
      return await db.insert('wp_user', user.toMap());
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  //Insert Master Password information. Relation: one-to-one
  Future<int> insertMasterPassword(MasterPswd masterPswd) async {
    try {
      final db = await this.db;
      return await db.insert('master_pswd', masterPswd.toMap());
    } catch(e) {
      print('Error inserting master password: $e');
      return -1;
    }
  }

  //User Retrieval
  Future<List<WPUser>> getAllUsers() async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query('wp_user');
    return result.map((map) => WPUser.fromMap(map)).toList();
  }

  //Master Password Retrieval
  Future<List<MasterPswd>> getMasterPasswords() async {
    final db = await this.db;
    final List<Map<String, dynamic>> result = await db.query('master_pswd');
    return result.map((map) => MasterPswd.fromMap(map)).toList();
  }

  Future<void> close() async {
    final db = await this.db;
    db.close();
  }
}