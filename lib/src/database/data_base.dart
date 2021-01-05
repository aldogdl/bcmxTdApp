import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBApp {

  final nombreBD = 'bcmxtds.db';

  static Database _database;
  static final DBApp db = DBApp._();
  DBApp._();

  /* */
  Future<Database> get abrir async {

    if(_database != null){
      if(_database.isOpen) {
        return _database;
      }
    }

    _database = await initDB();
    return _database;
  }

  /* */
  Future<void> borrarBd() async {

    Directory directorioDocument = await getApplicationDocumentsDirectory();
    final pathAlArchivoDb = join(directorioDocument.path, nombreBD);
    await deleteDatabase(pathAlArchivoDb);
  }

  /* */
  Future<Database> initDB() async {

    Directory directorioDocument = await getApplicationDocumentsDirectory();
    final pathAlArchivoDb = join(directorioDocument.path, nombreBD);
    
    return await openDatabase(
      pathAlArchivoDb,
      version: 1,
      onOpen: (db) async {},
      onCreate: (Database db, int version) async {

        await db.execute(
          'CREATE TABLE user ('
          ' id INTEGER,'
          ' usname TEXT,'
          ' uspass TEXT,'
          ' role TEXT,'
          ' token TEXT'
          ');'
        );

        await db.execute(
          'CREATE TABLE prosroto ('
          ' proceso TEXT,'
          ' route TEXT,'
          ' metas TEXT,'
          ' content TEXT'
          ');'
        );

      },
      singleInstance: true,
      readOnly: false,
    );
  }

}