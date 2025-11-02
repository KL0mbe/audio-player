import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  Database? db;
  // use db only from in here

  Future<void> init() async {
    await openDB();
    // we might not need to call opendb from here. doesnt really make sense
    // maybe just call it from database service
    // and extracting of the current file
    // it should be stored in its own table
    // using the primary key of that file
  }

  Future<void> openDB() async {
    if (db != null && db!.isOpen) return;
    final databaseDirectory = await getLibraryDirectory();
    final dbPath = join(databaseDirectory.path, "master_db.db");
    db = await openDatabase(dbPath, version: 1, onConfigure: _onConfigure, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {}

  _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE files (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT NOT NULL UNIQUE,
      fast_forward INTEGER,
      rewind INTEGER,
      last_position REAL,
      is_skip BOOLEAN DEFAULT FALSE,
      speed REAL
        )""");
    await db.execute("""
      CREATE TABLE current_file (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      file_id INTEGER,
      FOREIGN KEY (file_id)
      REFERENCES files(id)
      ON DELETE SET NULL
      ON UPDATE CASCADE
    )""");
  }
}
