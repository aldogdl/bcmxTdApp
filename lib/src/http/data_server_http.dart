import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


import '../../config/globals.dart' as globals;

class DataServerHttp {

  String _apiBase = '${globals.uriBaseDb}apis/bcmxTds/savedata/';

  /// ::buscarUltimasTarjetas
  Future<http.Response> buscarUltimasTarjetas(Map<String, dynamic> dataUser) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}apis/bcmxTds/app/${dataUser['id']}/get-ultimas-tarjetas/');
    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer ${dataUser['token']}';
    return await http.Response.fromStream(await req.send());
  }

  /// ::getTarjetasConPalClas
  Future<http.Response> getTarjetasConPalClas(String palcla, String token) async {
    
    Uri uri = Uri.parse('${globals.uriBaseDb}apis/bcmxTds/app/$palcla/buscar-tarjetas-palcla/');
    final req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $token';
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> crearUserNew(Map<String, dynamic> data, String tokenServer) async {

    Uri uri = Uri.parse('${this._apiBase}save-data-user/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(data);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> sendDataContact(Map<String, dynamic> data, String tokenServer) async {

    Uri uri = Uri.parse('${this._apiBase}save-datos-negocio/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(data);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> sendDataLinks(Map<String, dynamic> data, String tokenServer) async {

    Uri uri = Uri.parse('${this._apiBase}save-data-links/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(data);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> sendDataDisenio(Map<String, dynamic> data, String tokenServer) async {

    Uri uri = Uri.parse('${this._apiBase}save-data-disenio/');
    final req = http.MultipartRequest('POST', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode(data);
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> sendDataFoto(Map<String, dynamic> dataFoto, String tokenServer) async {

    Uri uri = Uri.parse('${this._apiBase}save-data-foto/');

    final req = http.MultipartRequest("POST", uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
   
    List<int> imageData = dataFoto['bytes'].buffer.asUint8List();

    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'imagen',
      imageData,
      filename: dataFoto['nameFile'],
      contentType: MediaType("image", dataFoto['ext']),
    );

    // add file to multipart
    req.files.add(multipartFile);
    dataFoto = null;
    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> sendDataNombresFotos(List<String> nombres, int idDis, String tokenServer) async {

    Uri uri = Uri.parse('${this._apiBase}save-data-foto-nombres/');

    final req = http.MultipartRequest("POST", uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';
    req.fields['data'] = json.encode({'idDis': idDis, 'nombres': nombres});

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getFranquicias(String tokenServer) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}apis/bcmxTds/app/get-franquicias/');

    http.MultipartRequest req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getCategos(String tokenServer) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}apis/bcmxTds/app/get-categos/');

    http.MultipartRequest req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getSubCategos(String tokenServer, int idCat) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}apis/bcmxTds/app/$idCat/get-subcategos/');

    http.MultipartRequest req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> getIdCategoByIdSubCatego(String tokenServer, idSubCat) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}apis/bcmxTds/app/$idSubCat/get-id-categos-by-is-sub/');

    http.MultipartRequest req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';

    return await http.Response.fromStream(await req.send());
  }

  ///
  Future<http.Response> marckWithPagado(String tokenServer, idTd) async {

    Uri uri = Uri.parse('${globals.uriBaseDb}apis/bcmxTds/app/$idTd/marck-with-pagado/');

    http.MultipartRequest req = http.MultipartRequest('GET', uri);
    req.headers['Authorization'] = 'Bearer $tokenServer';

    return await http.Response.fromStream(await req.send());
  }


}