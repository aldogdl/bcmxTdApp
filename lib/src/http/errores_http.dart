import 'package:http/http.dart' as http;

import '../repository/user_repository.dart' as emGetToken;

class ErroresHttp {


  ///
  Future<Map<String, dynamic>> tratarError(http.Response errores) async {

    assert((){
      print(errores.statusCode);
      print(errores.body);
      return true;
    }());

    switch (errores.statusCode) {
      case 401:
        if(errores.body.contains('Invalid ')) {
          return {
            'abort' : true,
            'msg' :'Credenciales',
            'body': 'Tus credenciales no son validas'
          };
        }
        if(errores.body.contains('Unable to load ')) {
          return {
            'abort' : true,
            'msg' :'SIN Autorización',
            'body': 'Tus Permisos no son Correcto'
          };
        }
        if(errores.body.contains('Expired ')) {

          String token = await emGetToken.UserRepository().refreshTokenServerBackground();
          return {
            'abort' : true,
            'msg' :'Token de Servidor',
            'body': 'Tus permisos han caducado',
            'token': token
          };
        }
        break;
      case 404:
        
        break;
      default:
    }
    return new Map();
  }
}