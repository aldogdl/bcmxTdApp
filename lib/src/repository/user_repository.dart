import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../database/data_base.dart';
import '../http/user_http.dart';
import '../http/errores_http.dart';
import '../widgets/alerts_varios.dart';

class UserRepository {

  ErroresHttp erroresHttp = ErroresHttp();
  UserHttp userHttp = UserHttp();
  AlertsVarios alertsVarios = AlertsVarios();

  Map<String, dynamic> result = {'abort': false, 'msg': 'ok', 'body': ''};
  
  /// @see InitConfigController::_initWidget
  Future<bool> hasCredentialsUser() async {

    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<dynamic> user = await db.query('user');
      return (user.isNotEmpty) ? true : false;
    }
    return true;
  }

  /// @see DataServerRepository::sendDataContact
  Future<int> getIdUser() async {

    int idUSer = 0;
    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<dynamic> user = await db.query('user');
      if(user.isNotEmpty) {
        idUSer = user.first['id'];
      }
    }
    return idUSer;
  }

  /// @see this::refreshTokenServer
  Future<Map<String, dynamic>> getCredencials() async {

    Map<String, dynamic> dataUser = new Map();
    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<dynamic> user = await db.query('user');
      if(user.isNotEmpty) {
        dataUser =  {
          'usname': user.first['usname'],
          'uspass': user.first['uspass']
        };
      }
    }
    return dataUser;
  }

  /// @see this::refreshTokenServer
  Future<bool> updateToken(String tokenServer) async {

    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<dynamic> user = await db.query('user');
      if(user.isNotEmpty) {
        int idUser = user.first['id'];
        int res = await db.update('user', {'token':tokenServer}, where: 'id = ?', whereArgs: [idUser]);
        return (res > 0) ? true : false;
      }
    }
    return false;
  }

  /// @see InitConfigController::_checkTokenOfUser
  Future<String> getTokenServerByUserInLocal() async {

    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<dynamic> user = await db.query('user');
      return (user.isNotEmpty) ? user.first['token'] : '';
    }
    return '';
  }

  /// @see DataServerRepository::buscarUltimasTarjetas
  Future<Map<String, dynamic>> getDataForSeachLastTarjetas() async {

    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<dynamic> user = await db.query('user');
      if(user.isNotEmpty){
        return {
          'id': user.first['id'],
          'token' : user.first['token']
        };
      }
    }
    return new Map();
  }

  /// @see this::firstAutenticacion
  Future<bool> saveDataInBd(Map<String, dynamic> dataUser) async {

    int cant = 0;
    Database db = await DBApp.db.abrir;
    if(db.isOpen) {
      List<dynamic> user = await db.query('user');
      if(user.isEmpty) {
        cant = await db.insert('user', dataUser);
      }
      return (cant > 0) ? true : false;
    }

    return false;
  }

  /// @see InitConfigController::_checkTokenOfUser
  Future<bool> checkTokenServer(String token) async {

    final reServer = await userHttp.checkCaducidadDelToken(token);
    if(reServer.statusCode == 200) {
      final body = json.decode(reServer.body);
      return body[0];
    }else{
      return false;
    }
  }

  /// @see FrmContac::_checkUnicUsername
  Future<bool> checkUnicUsername(String token) async {

    final reServer = await userHttp.checkUnicUsername(token);
    if(reServer.statusCode == 200) {
      final body = json.decode(reServer.body);
      return body[0];
    }else{
      return false;
    }
  }

  /// @see FrmLoginWidget::_enviar
  /// 
  /// Utilizado para la primera ves que hacen login los administradores
  Future<bool> firstAutenticacion(BuildContext context, Map<String, dynamic> dataUser) async {

    alertsVarios.cargando(context, titulo: 'LOGIN', body: 'Enviando Credenciales');
    
    final reServer = await userHttp.hacerLogin(dataUser);
    if(reServer.statusCode == 200) {

      final body = json.decode(reServer.body);
      if(body['token'].length > 20) {

        dataUser['token'] = body['token'];
        bool isOk = await this.getRoleOfUser(dataUser);
        if(!isOk) {
          await _showDialogError(context);
        } else {
          dataUser['id'] = this.result['body']['u_id'];
          dataUser['role'] = this.result['body']['u_roles'][0];
          isOk = await this.saveDataInBd(dataUser);
          if(!isOk) {
             await _showDialogError(context);
          }else{
            return true;
          }
        }

      }else{

        this.result['msg']  = 'TOKEN ERRONEO';
        this.result['body'] = 'Inténtalo nuevamente, Error de consistencia en el Token de Acceso';
        await _showDialogError(context);

      }

    }else{
      this.result = await erroresHttp.tratarError(reServer);
      await _showDialogError(context);
    }

    return false;
  }

  /// @see InitConfigController::_checkTokenOfUser
  /// 
  /// Utilizado para recuperar un nuevo token server
  Future<bool> refreshTokenServer(BuildContext context) async {

    alertsVarios.cargando(context, titulo: 'RECOVERY TOKEN', body: 'Recuperando nueva llave de acceso, espera un momento porfavor');
    Map<String, dynamic> dataUser = await getCredencials();
    
    final reServer = await userHttp.hacerLogin(dataUser);
    if(reServer.statusCode == 200) {

      final body = json.decode(reServer.body);
      if(body['token'].length > 20) {

        bool res = await updateToken(body['token']);
        Navigator.of(context).pop();
        return res;
      }else{

        this.result['msg']  = 'TOKEN ERRONEO';
        this.result['body'] = 'Inténtalo nuevamente, Error de consistencia en el Token de Acceso';
        await _showDialogError(context);

      }

    }else{
      this.result = await erroresHttp.tratarError(reServer);
      await _showDialogError(context);
    }

    return false;
  }

  /// @see InitConfigController::_checkTokenOfUser
  /// 
  /// Utilizado para recuperar un nuevo token server
  Future<String> refreshTokenServerBackground() async {

    Map<String, dynamic> dataUser = await getCredencials();
    
    final reServer = await userHttp.hacerLogin(dataUser);
    if(reServer.statusCode == 200) {

      final body = json.decode(reServer.body);
      if(body['token'].length > 20) {
        await updateToken(body['token']);
        return body['token'];
      }

    }

    return '';
  }

  /// @see FrmLoginWidget::_enviar
  Future<bool> getRoleOfUser(Map<String, dynamic> dataUser) async {

    final reServer = await userHttp.getRoleOfUser(dataUser['usname'], dataUser['token']);
    if(reServer.statusCode == 200) {
      final body = json.decode(reServer.body);
      this.result['body'] = body;
      return true;
    }else{
      this.result = await erroresHttp.tratarError(reServer);
    }

    return false;
  }

  ///
  Future<void> _showDialogError(BuildContext context) async {
    Navigator.of(context).pop();
    await alertsVarios.entendido(context, titulo: this.result['msg'], body: this.result['body'], icono: Icons.close);
  }
}