import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list_with_sqflite/models/database_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._constructor();
  static Database? _db;

  final String _forcastTableName = 'task';
  final String _taskIdColumnName = 'id';
  final String _taskCreatedAtColumnName = 'createdAt';
  final String _taskTitleColumnName = 'title';
  final String _taskDetailsColumnName = 'task';

  DatabaseService._constructor();

  Future<Database> database() async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getDatabase();
      return _db!;
    }
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'master_db.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_forcastTableName(
          $_taskIdColumnName INTEGER PRIMARY KEY,
          $_taskCreatedAtColumnName TEXT NOT NULL,
          $_taskTitleColumnName TEXT NOT NULL,
          $_taskDetailsColumnName TEXT NOT NULL
        )
      ''');
      },
    );
    return database;
  }

  void addtask(
      {required String title, required String details}) async {
    
    final Database db = await database();
    await db.insert(
      _forcastTableName,
      {
        _taskCreatedAtColumnName: DateTime.now(),
        _taskTitleColumnName: title,
        _taskDetailsColumnName: details,
      },
    );
  }

  Future<List<DatabaseModel>> getTask() async {
    final db = await database();
    final data = await db.query(_forcastTableName);
    List<DatabaseModel> tasks = data.map((e) {
      return DatabaseModel(
        id: e[_taskIdColumnName] as int, // Casting to int
        createdAt: e[_taskCreatedAtColumnName] as DateTime, // Casting to double
        tile: e[_taskTitleColumnName] as String, // Casting to double
        details: e[_taskDetailsColumnName] as String, // Casting to String
      );
    }).toList();
    return tasks;
  }

  Future<void> deleteAlltasks() async {
    final db = await database();
    await db.delete(_forcastTableName);
  }
}