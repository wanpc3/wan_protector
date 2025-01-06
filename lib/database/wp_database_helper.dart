import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'table_models/acc_entry.dart';
import 'table_models/master_pswd.dart';
import 'table_models/wp_user.dart';

//Import encryption method
import '../encryption/encryption_helper.dart';

class WPDatabaseHelper {

  static const _database_name = 'wan_protector.db';

  static final WPDatabaseHelper instance = WPDatabaseHelper._instance();
  static Database? _database;

  WPDatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _database_name);

    print("Database path: $path");

    final db =  await openDatabase(
      path, 
      version: 2, 
      onCreate: _onCreate, 
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
        print('Foreign keys enabled');
      },
    );

    return db;
  }

  //Locate database file path
  Future<String> getDatabaseFilePath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'wan_protector.db');
    return path;
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop the old table and create a new one
      await db.execute('DROP TABLE IF EXISTS wp_user');
      await db.execute('DROP TABLE IF EXISTS acc_entry');
      await db.execute('DROP TABLE IF EXISTS user_pswd');
      await _createUserTable(db);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createUserTable(db);
    await _createMasterPswdTable(db);
    await _createPswdCategoryTable(db);
    await _createAccEntryTable(db);
    await _createUserPswdTable(db);
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE wp_user (
        user_no INTEGER PRIMARY KEY AUTOINCREMENT,
        email VARCHAR(255) UNIQUE NOT NULL
      )
    ''');
  }

  Future<void> _createMasterPswdTable(Database db) async {
    await db.execute('''
      CREATE TABLE master_pswd (
        master_pswd_no INTEGER PRIMARY KEY AUTOINCREMENT,
        master_pswd_text TEXT NOT NULL,
        user_no INTEGER NOT NULL,
        FOREIGN KEY (user_no) REFERENCES wp_user (user_no)
      )
    ''');
  }

  Future<void> _createPswdCategoryTable(Database db) async {
  await db.execute('''
    CREATE TABLE pswd_category(
      pswd_category_no INTEGER PRIMARY KEY AUTOINCREMENT,
      category_name VARCHAR(255) UNIQUE NOT NULL
    )
  ''');
}


  Future<void> _createAccEntryTable(Database db) async {
    await db.execute('''
      CREATE TABLE acc_entry(
        entry_no INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(255) NOT NULL,
        acc_username VARCHAR(255) NOT NULL,
        acc_url VARCHAR(255),
        notes TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _createUserPswdTable(Database db) async {
    await db.execute('''
      CREATE TABLE user_pswd(
        user_pswd_no INTEGER PRIMARY KEY AUTOINCREMENT,
        user_pswd_text TEXT NOT NULL,
        encryption_method TEXT DEFAULT 'AES-256',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        entry_no_ref INTEGER NOT NULL,
        FOREIGN KEY (entry_no_ref) REFERENCES acc_entry(entry_no) ON DELETE CASCADE
      )
    ''');
  }

  //Insert User information. Relation: one-to-one
  Future<int> insertUser(WPUser user) async {
    try {
      return await insert('wp_user', user.toMap());
    } catch (e) {
      print('Error inserting user: $e');
      return -1;
    }
  }

  //Insert Master Password information. Relation: one-to-one
  Future<int> insertMasterPassword(MasterPswd masterPswd) async {
    try {
      return await insert('master_pswd', masterPswd.toMap());
    } catch(e) {
      print('Error inserting master password: $e');
      return -1;
    }
  }

  //Insert Entry.
  Future<int> insertAccEntry(AccEntry entry) async {
    final db = await this.db;

    // Get category_no_ref from the fetched category
    final result = await db.insert('acc_entry', {
      'title': entry.accTitle,
      'acc_username': entry.accUsername,
      'acc_url': entry.accUrl,
      'notes': entry.addNotes,
    });
    
    print('Account entry inserted: $result');
    return result;
  }

  //Login method
  Future<bool> login(WPUser user, MasterPswd masterPswd) async {
    final db = await this.db;

    //Check if the email exists in the wp_user table
    var emailResult = await db.rawQuery(
      "SELECT * FROM wp_user WHERE email = ?", [user.email]
    );

    if (emailResult.isEmpty) {
      return false;
    }

    //Get user_no from the result
    int userNo = emailResult.first['user_no'] as int;

    //Check if the master password exist for the given user
    var masterPasswordResult = await db.rawQuery(
      "SELECT * FROM master_pswd WHERE user_no = ? AND master_pswd_text = ?",
      [userNo, EncryptionHelper.encryptText(masterPswd.masterPswdText)]
    );

    return masterPasswordResult.isNotEmpty;
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await this.db;
    return await db.insert(table, values);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await this.db;
    return await db.query(table);
  }

  Future<void> close() async {
    final db = await this.db;
    db.close();
  }
}