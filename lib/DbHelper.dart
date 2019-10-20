import 'package:apiapk/Notedata.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  String noteTable = 'note_table';

  String colid = 'id';
  String coltitle = 'title';
  String coldeskripsion = 'description';
  String colpriority = 'priority';
  String coldate = 'date';

  DbHelper._createInstance();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance();
    }
    return _dbHelper;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colid INTEGER PRIMARY KEY AUTOINCREMENT, $coltitle TEXT,'
        '$coldeskripsion TEXT, $colpriority INTEGER, $coldate TEXT)');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizeDatabase();
    }
    return _database;
  }

  Future<Database> initalizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

 Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
  // var result = await db.rawQuery('SELECT * FROM $noteTable orde by $colpriority ASC');
    var result = await db.query(noteTable, orderBy: '$colpriority ASC');
    return result;
  }
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
  Future<int> updateNote(Note note) async{
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colid = ?', whereArgs: [note.id]);
    return result;
  }
  Future<int> deleteNote(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colid = $id');
    return result;
  }
  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> noteList = List<Note>();

    for(int i = 0;i < count; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

}
