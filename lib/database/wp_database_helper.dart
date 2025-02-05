import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:wan_protector/database/table_models/user_pswd.dart';
import 'table_models/acc_entry.dart';
import 'table_models/master_pswd.dart';
import 'table_models/newsletter_subscriber.dart';

//Import encryption method
import '../encryption/encryption_helper.dart';

class WPDatabaseHelper {

  static const _database_name = 'wan_protector.db';
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static final WPDatabaseHelper instance = WPDatabaseHelper._instance();
  static Database? _database;

  WPDatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databasesPath = documentsDirectory.path;
    final path = join(databasesPath, _database_name);

    print("Database path: $path");

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        print('Creating database version $version...');
        await _onCreate(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('Upgrading database from $oldVersion to $newVersion...');
        await _onUpgrade(db, oldVersion, newVersion);
      },
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
        print('Database opened with foreign keys enabled');
      },
    );
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
      await db.execute('DROP TABLE IF EXISTS newsletter_subscriber');
      await db.execute('DROP TABLE IF EXISTS master_pswd');
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
      CREATE TABLE newsletter_subscriber (
        newsletter_id INTEGER PRIMARY KEY AUTOINCREMENT,
        email VARCHAR(255) UNIQUE NOT NULL,
        newsletter VARCHAR(20),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _createMasterPswdTable(Database db) async {
    await db.execute('''
      CREATE TABLE master_pswd (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        master_pswd_text TEXT NOT NULL
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

  //User registration
  //Insert Master Password information.
  Future<int> insertMasterPassword(MasterPswd masterPswd) async {
    try {
      return await insert('master_pswd', masterPswd.toMap());
    } catch(e) {
      print('Error inserting master password: $e');
      return -1;
    }
  }

  //Login method
  Future<bool> login(String inputPswd) async {
    final db = await this.db;

    String encryptedInputPassword = EncryptionHelper.encryptText(inputPswd);

    print("Input Encrypted Master Password: $encryptedInputPassword");

    //Check if the master password exist for the given user
    var masterPasswordResult = await db.rawQuery(
      "SELECT * FROM master_pswd WHERE master_pswd_text = ?",
      [encryptedInputPassword]
    );

    if (masterPasswordResult.isNotEmpty) {
      await _secureStorage.write(key: 'isLoggedIn', value: 'true');
      return true;
    }

    return false;
  }

  // To check if the user is logged in
  Future<bool> isLoggedIn() async {
    String? isLoggedIn = await _secureStorage.read(key: 'isLoggedIn');
    return isLoggedIn == 'true';
  }

  //Insert Entry.
  Future<int> insertAccEntry(AccEntry entry) async {
    final db = await this.db;

    final result = await db.insert('acc_entry', {
      'title': entry.accTitle,
      'acc_username': entry.accUsername,
      'acc_url': entry.accUrl,
      'notes': entry.addNotes,
    });
    
    print('Account entry inserted: $result');
    return result;
  }

  //Update Entry.
  Future<int> updateAccEntry(AccEntry entry) async {
    final db = await this.db;

    final result = await db.update(
      'acc_entry',
      entry.toMap(),
      where: 'entry_no = ?',
      whereArgs: [entry.entryNo],
    );

    print('Account entry updated: $result');
    return result;
  }

  //Update User Password
  Future<int> updateUserPswd(UserPswd userPswd) async {
    final db = await this.db;

    final result = await db.update(
      'user_pswd',
      userPswd.toMap(),
      where: 'user_pswd_no = ?',
      whereArgs: [userPswd.entryNoRef],
    );

    print('User password updated: $result');
    return result;
  }

  //Select entry by its primary key
  Future<AccEntry?> fetchAccEntry(int entryNo) async {
    final db = await this.db;

    final get_acc_entry = await db.query(
      'acc_entry',
      where: 'entry_no = ?',
      whereArgs: [entryNo],
    );

    if (get_acc_entry.isNotEmpty) {
      return AccEntry.fromMap(get_acc_entry.first);
    }

    return null;
  }

  //Select user password by its primary key
  //Remember in this case acc_entry and user_pswd are one-to-one relation
  Future<UserPswd?> fetchUserPswdByEntryNo(int entryNo) async {
    final db = await this.db;

    final get_user_pswd = await db.query(
      'user_pswd',
      where: 'entry_no_ref = ?',
      whereArgs: [entryNo],
    );

    if (get_user_pswd.isNotEmpty) {
      return UserPswd.fromMap(get_user_pswd.first);
    }

    return null;
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