import 'package:http/http.dart' as http;
import '../../config/globals.dart' as globals;

class UserHttp {

  String _urlToApi = '${globals.uriBaseDb}apis/bcmxTds/app';

  ///
  Future<http.Response> checkCaducidadDelToken(String tokenServer) async {

    Uri uri = Uri.parse('${this._urlToApi}/checar-caducidad-token/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    return http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> hacerLogin(Map<String, dynamic> dataUser) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}login_admin/login_check');
    final req = http.MultipartRequest('POST', uri);
    req.fields['_usname'] = dataUser['usname'];
    req.fields['_uspass'] = dataUser['uspass'];
    return http.Response.fromStream(await req.send());

  }

  ///
  Future<http.Response> checkUnicUsername(String username) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}login_tds/check_username');
    final req = http.MultipartRequest('POST', uri);
    req.fields['username'] = username;
    return http.Response.fromStream(await req.send());

  }

  ///
  Future<http.Response> getRoleOfUser(String username, String tokenServer) async {

    Uri uri = Uri.parse('${this._urlToApi}/$username/get-role-user/');

    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    return http.Response.fromStream(await req.send());
  }
}