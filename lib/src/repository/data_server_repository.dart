import 'dart:convert';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../http/errores_http.dart';
import '../http/data_server_http.dart';
import '../repository/user_repository.dart';


class DataServerRepository {

  DataServerHttp dataServerHttp = DataServerHttp();
  UserRepository emUser = UserRepository();
  ErroresHttp errores = ErroresHttp();

  ///
  Map<String, dynamic> result = {'abort': false, 'msg': 'ok', 'body': ''};


  /// Buscando las Ultimas Tarjetas Digitales vendidas por el usuario
  Future<List<Map<String, dynamic>>> buscarUltimasTarjetas() async {

    Map<String, dynamic> dataUser = await emUser.getDataForSeachLastTarjetas();

    final reServer = await dataServerHttp.buscarUltimasTarjetas(dataUser);
    if(reServer.statusCode == 200) {
      List<dynamic> res = json.decode(reServer.body);
      if(res.isNotEmpty) {
        return new List<Map<String, dynamic>>.from(res);
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return new List();
  }

  /// Buscando las Tarjetas Digitales que coinsidan con la palabra clave
  Future<List<Map<String, dynamic>>> getTarjetasConPalClas(String palcla) async {

    String token = await emUser.getTokenServerByUserInLocal();
    palcla = palcla.trim().toLowerCase().replaceAll(' ', '+');
    
    final reServer = await dataServerHttp.getTarjetasConPalClas(palcla, token);
    if(reServer.statusCode == 200) {
      List<dynamic> res = json.decode(reServer.body);
      if(res.isNotEmpty) {
        return new List<Map<String, dynamic>>.from(res);
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return new List();
  }

  /// Enviando los datos de contacto
  Future<bool> crearUserNew(Map<String, dynamic> data, String tokenServer) async {

    final reServer = await dataServerHttp.crearUserNew(data, tokenServer);
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      if(!res['abort']) {
        result['body'] = res['body'];
        return true;
      }else{
        this.result = res;
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return false;
  }

  /// Enviando los datos de contacto
  Future<bool> sendDataContact(Map<String, dynamic> data, String tokenServer) async {

    data['vendedor'] = await emUser.getIdUser();
    final reServer = await dataServerHttp.sendDataContact(data, tokenServer);
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      if(!res['abort']) {
        this.result['body'] = res['body'];
        return true;
      }else{
        this.result = res;
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return false;
  }

  /// Enviando los datos de los links
  Future<bool> sendDataLinks(Map<String, dynamic> data, String tokenServer) async {

    final reServer = await dataServerHttp.sendDataLinks(data, tokenServer);
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      if(!res['abort']) {
        return true;
      }else{
        this.result = res;
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return false;
  }

  /// Enviando los datos de los links
  Future<bool> sendDataDisenio(Map<String, dynamic> data, String tokenServer) async {

    final reServer = await dataServerHttp.sendDataDisenio(data, tokenServer);
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      if(!res['abort']) {
        this.result['body'] = res['body'];
        return true;
      }else{
        this.result = res;
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return false;
  }

  /// Enviando los datos de los links
  Future<bool> sendDataFoto({
    Map<String, dynamic> dataFoto,
    int idTd,
    String tokenServer
  }) async {

    Asset asset = Asset(
      dataFoto['identifier'],
      dataFoto['name'],
      dataFoto['originalWidth'],
      dataFoto['originalHeight']
    );
    dataFoto['ext'] = await determinarExtencion(dataFoto['name']);
    if(dataFoto['ext'] == ''){ return false; }
    //Preparando data
    String nombreFile = '$idTd' + '_foto_${dataFoto['id']}.${dataFoto['ext']}';

    Map<String, dynamic> data = {
      'ext'  : dataFoto['ext'],
      'nameFile' : nombreFile,
      'bytes' : await asset.getByteData(),
    };

    final reServer = await dataServerHttp.sendDataFoto(data, tokenServer);
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      if(!res['abort']) {
        this.result['body'] = nombreFile;
        return true;
      }else{
        this.result = res;
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return false;
  }

  /// Enviando los datos de los links
  Future<bool> sendDataNombresFotos(List<String> nombres, int idDis, String tokenServer) async {

    final reServer = await dataServerHttp.sendDataNombresFotos(nombres, idDis, tokenServer);
    if(reServer.statusCode == 200) {
      final res = json.decode(reServer.body);
      if(!res['abort']) {
        return true;
      }else{
        this.result = res;
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }
    return false;
  }

  ///
  Future<String> determinarExtencion(String fileName) async {

    List<String> pedazos = fileName.split('.');
    String ext = pedazos.last;
    if(ext.length >= 3) {
      return ext;
    }else{
      return '';
    }
  }

  /// Recuperamos las franquicias que existan en el servidor
  Future<List<Map<String, dynamic>>> getFranquicias(String tokenServer) async {
    
    var reServer = await dataServerHttp.getFranquicias(tokenServer);
    if(reServer.statusCode == 200) {

      var franqs = json.decode(reServer.body);
      if(franqs.length > 0) {
        return List<Map<String, dynamic>>.from(franqs);
      }

    }else{
      this.result = await errores.tratarError(reServer);
    }

    return new List();
  }

  /// Recuperamos las categorias que existan en el servidor
  Future<List<Map<String, dynamic>>> getCategos(String tokenServer) async {
    
    var reServer = await dataServerHttp.getCategos(tokenServer);
    if(reServer.statusCode == 200) {

      var franqs = json.decode(reServer.body);
      if(franqs.length > 0) {
        return List<Map<String, dynamic>>.from(franqs);
      }

    }else{
      this.result = await errores.tratarError(reServer);
    }

    return new List();
  }

  /// Recuperamos las sub categorias que existan en el servidor
  Future<List<Map<String, dynamic>>> getSubCategos(String tokenServer, int idCat) async {
    
    var reServer = await dataServerHttp.getSubCategos(tokenServer, idCat);
    if(reServer.statusCode == 200) {

      var franqs = json.decode(reServer.body);
      if(franqs.length > 0) {
        return List<Map<String, dynamic>>.from(franqs);
      }

    }else{
      this.result = await errores.tratarError(reServer);
    }

    return new List();
  }

  /// Recuperamos las sub categorias que existan en el servidor
  Future<int> getIdCategoByIdSubCatego(String tokenServer, int idsubCat) async {
    
    var reServer = await dataServerHttp.getIdCategoByIdSubCatego(tokenServer, idsubCat);
    if(reServer.statusCode == 200) {

      var franqs = json.decode(reServer.body);
      if(franqs.length > 0) {
        return franqs[0];
      }

    }else{
      this.result = await errores.tratarError(reServer);
    }

    return 0;
  }

  /// Marcar el servicio como pagado
  Future<int> marckWithPagado(String tokenServer, int idTd) async {

    //code :: 1 = pagado  ||  0 = no Pagado  ||  2 = Error al guardar
    
    int result = 2;
    var reServer = await dataServerHttp.marckWithPagado(tokenServer, idTd);
    if(reServer.statusCode == 200) {
      var res = json.decode(reServer.body);
      if(res.length > 0) {
        result = res[0];
      }
    }else{
      this.result = await errores.tratarError(reServer);
    }

    return result;
  }

}