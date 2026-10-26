import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqliteHelper {
  SqliteHelper._privateConstructor();

  static final SqliteHelper instance = SqliteHelper._privateConstructor();

  static Database? _database;
  static bool _factoryInitialized = false;

  Future<void> _initializeDatabaseFactory() async {
    if (_factoryInitialized) return;

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    _factoryInitialized = true;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    await _initializeDatabaseFactory();

    final databasePath = kIsWeb
        ? 'contact_database_web.db'
        : p.join(await getDatabasesPath(), 'contact_database.db');

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            email TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertContact(Map<String, Object?> contact) async {
    final db = await database;
    return db.insert('contacts', contact);
  }

  Future<List<Map<String, Object?>>> getContacts() async {
    final db = await database;

    return db.query('contacts', orderBy: 'name COLLATE NOCASE ASC');
  }

  Future<int> updateContact(int id, Map<String, Object?> contact) async {
    final db = await database;

    return db.update('contacts', contact, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteContact(int id) async {
    final db = await database;

    return db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}