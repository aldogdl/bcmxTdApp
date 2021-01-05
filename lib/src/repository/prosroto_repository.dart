import 'dart:convert';
import 'package:sqflite_common/sqlite_api.dart';

import '../database/data_base.dart';
import '../widgets/alerts_varios.dart';

class ProsRotoRepository {

  AlertsVarios alertsVarios = AlertsVarios();
  Map<String, dynamic> result = {'abort': false, 'msg': 'ok', 'body': ''};

  ///
  Future<Database> _getDb() async {

    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      return db;
    }
    return null;
  }

  ///
  Future<bool> setProceso(
    String proceso,
    String ruta,
    Map<String, dynamic> contenido,
    {Map<String, dynamic> metas}
  ) async {

    Database db = await _getDb();
    if(db != null) {

      List has = await db.query('prosroto');

      // Si algo existe, lo eliminamos
      if(has.isNotEmpty){
        await db.delete('prosroto');
      }
      Map<String, dynamic> values = {
        'proceso' : proceso,
        'route'   : ruta,
        'metas'   : (metas == null) ? '0' : json.encode(metas),
        'content' : json.encode(contenido)
      };
      int result = await db.insert('prosroto', values);
      return (result > 0) ? true : false;
    }

    return false;
  }

  ///
  Future<bool> hasProceso() async {

    Database db = await _getDb();
    bool res = false;
    if(db != null) {
      List has = await db.query('prosroto');
      if(has.isNotEmpty) {
        result['abort'] = false;
        result['msg'] = has.first['proceso'];
        result['body'] = {
          'proceso' : has.first['proceso'],
          'route'   : has.first['route'],
          'metas'   : (has.first['metas'] != '0') ? json.decode(has.first['metas']) : has.first['metas'],
          'content' : json.decode(has.first['content'])
        };
        return true;
      }else{
        return false;
      }
    }
    return res;
  }

  ///
  Future<void> deleteProceso() async {

    Database db = await _getDb();
    if(db != null) {
      await db.delete('prosroto');
    }
    return;
  }

}