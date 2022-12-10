import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_db/models/student_model.dart';


class DatabaseHelper {
  /// static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;
   static final DatabaseHelper instance = DatabaseHelper._instance();
  DatabaseHelper._instance();

  String TableName = 'student_table';
  String colId = 'rollNo';
  String colName = 'name';
  String colAge = 'age';
  // Task Tables
  // Id | Title | Date | Priority | Status
  // 0     ''      ''      ''         0
  // 1     ''      ''      ''         0
  // 2     ''      ''      ''         0

  // Future<Database> get db async {
  //   if (_db == null) {
  //     _db = await _initDb();
  //   }
  //   return _db;
  // }
  Future<Database> get database async => _db ??= await _initDb();

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + '/student_list.db';
    final studentListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return studentListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $TableName($colId STRING PRIMARY KEY , $colName  TEXT,   $colAge INTEGER)',
    );
  }
  Future<List<Map<String, dynamic>>> getStudentMapList() async {
    //Database -db = await this.db;
      Database db = await this._initDb();
    final List<Map<String, dynamic>> result = await db.query(TableName);
    return result;
  }

  Future<List<Student>> getStudentList() async {
    final List<Map<String, dynamic>> taskMapList = await getStudentMapList();
    final List<Student> StudentList = [];
    taskMapList.forEach((taskMap) {
      StudentList.add(Student.fromMap(taskMap));
    });
    return StudentList;
  }

  Future<int> insertStudent(Student s) async {
    Database db = await this._initDb();
    final int result = await db.insert(TableName, s.toMap());
    return result;
  }

  Future<int> updateStudent(Student s) async {
    //Database db = await this.db;
    Database db = await this._initDb();
    final int result = await db.update(
      TableName,
      s.toMap(),
      where: '$colId = ?',
      whereArgs: [s.rollNo],
    );
    return result;
  }

  Future<int> deleteStudent(String id) async {
    //Database db = await this.db;
    Database db = await this._initDb();
    final int result = await db.delete(
      TableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteAllTask() async {
    //Database db = await this.db;
    Database db = await this._initDb();
    final int result = await db.delete(TableName);
    return result;
  }
}
