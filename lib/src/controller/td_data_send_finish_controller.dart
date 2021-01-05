import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/bg_sky_widget.dart';
import '../singletons/tds_singleton.dart';
import '../repository/data_server_repository.dart';
import '../repository/prosroto_repository.dart';
import '../../config/data_shared.dart';
import '../utils/text_utils.dart';

class TdDataSendFinishController extends StatefulWidget {

  TdDataSendFinishController({Key key}) : super(key: key);

  @override
  _TdDataSendFinishControllerState createState() => _TdDataSendFinishControllerState();
}

class _TdDataSendFinishControllerState extends State<TdDataSendFinishController> {

  TdsSingleton tdsSng = TdsSingleton();
  DataServerRepository emDataServer = DataServerRepository();
  ProsRotoRepository emRoto = ProsRotoRepository();
  TextUtils textUtils = TextUtils();

  BuildContext _context;
  GlobalKey<ScaffoldState>_keySkff = GlobalKey<ScaffoldState>();

  bool _isInit = false;
  bool _showError = false;
  bool _inProceso = false;

  String _tokenServer = '';
  String _haciendo = 'Procesando...';
  String _initProceso = 'createUser';
  List<String> _fotosNombres = new List();

  Map<String, dynamic> _procesos = {
    'createUser': {
      'hecho': false
    },
    'dataContac': {
      'hecho': false
    },
    'dataLinks': {
      'hecho': false
    },
    'dataDisenio': {
      'hecho': false
    },
    'dataFotoUno': {
      'hecho': false
    },
    'dataFotoDos': {
      'hecho': false
    },
    'dataFotoTre': {
      'hecho': false
    },
    'dataFotoCuatro': {
      'hecho': false
    },
    'dataFotosNombre': {
      'hecho': false
    }
  };

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_initWidget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._tokenServer = Provider.of<DataShared>(context, listen: false).tokenServer;
      this._context = context;
      context = null;
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(this._context).pushNamedAndRemoveUntil('td_data_send', (route) => false);
        return Future.value(true);
      },
      child: Scaffold(
        key: this._keySkff,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'ENVIANDO DATA',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 17
            ),
          ),
          backgroundColor: const Color(0xff0070B3),
        ),
        body: Stack(
          children: [
            BgSkyWidget(),
            Container(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height,
              child: Center(
                child: _cargando(),
              ),
            )
          ],
        ),
      )
    );
  }

  ///
  Future<void> _initWidget(_) async {

    await _sendData();
  }

  ///
  Widget _cargando() {

    return Container(
      width: MediaQuery.of(this._context).size.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(image: AssetImage('assets/images/send_data.jpg')),
          LinearProgressIndicator(),
          Text(
            'Enviando la Información al servidor, por favor, espera un ' +
            'momento para procesar los datos capturados.',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          const SizedBox(height: 30),
          Text(
            '${this._haciendo}',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.green
            ),
          ),
          const SizedBox(height: 10),
          (this._showError)
          ?
          Column(
            children: [
              Text(
                '${emDataServer.result['msg']}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red
                ),
              ),
              Divider(),
              Text(
                '${emDataServer.result['body']}',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red
                ),
              ),
              RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () async {
                  setState(() {
                    this._showError = false;
                    this._inProceso = false;
                  });
                  this._initProceso = 'createUser';
                  await _sendData();
                },
                child: Text(
                  'Reintentar',
                  textScaleFactor: 1,
                ),
              )
            ],
          )
          : SizedBox(height: 0)
        ],
      ),
    );
  }

  ///
  Future<void> _sendData() async {

    _sendDataUser().then((value) {

        if(!value){ return false; }
        _sendDataContact().then((value) {

        if(!value){ return false; }
        _sendDataLinks().then((value) {

          if(!value){ return false; }
          _sendDataDisenio().then((value) {

            if(!value){ return false; }
            _sendDataFotoUno().then((value) {

              if(!value){ return false; }
              _sendDataFotoDos().then((value) {

                if(!value){ return false; }
                _sendDataFotoTres().then((value) {

                  if(!value){ return false; }
                  _sendDataFotoCuatro().then((value) async {

                    if(!value){ return false; }
                      _sendDataNombresDeFotos().then((value) async {
                      if(!value){ return false; }

                      await _listoFin();
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
    
  }

  ///
  Future<bool> _sendDataUser() async {

    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Creando Usuario';
    });
    
    this._initProceso = 'createUser';
    if(this._procesos[this._initProceso]['hecho']){ return true; }
    this._inProceso = true;
    bool res = await emDataServer.crearUserNew(tdsSng.toJsonDataUser(), this._tokenServer);
    if(!res) {
      if(emDataServer.result.containsKey('token')) {
        this._tokenServer = emDataServer.result['token'];
        Provider.of<DataShared>(this._context, listen: false).setTokenServer(this._tokenServer);
      }
      setState(() {
        this._showError = true;
        this._inProceso = false;
      });
    }else{
      this._procesos[this._initProceso]['hecho'] = true;
      this._inProceso = false;
      tdsSng.idUser = emDataServer.result['body'];
      return res;
    }
    return false;
  }

  ///
  Future<bool> _sendDataContact() async {

    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Enviando Información General';
    });

    this._initProceso = 'dataContac';
    if(this._procesos[this._initProceso]['hecho']){ return true; }
    this._inProceso = true;
    Map<String, dynamic> dataContact = tdsSng.toJsonDataContac();
    Map<String, dynamic> dataGrales  = tdsSng.toJsonDataGenerales();
    dataContact.addAll(dataGrales);

    dataContact['queVende'] = textUtils.quitarAcentosToListPalabras(dataContact['queVende']);
    dataContact['requireFac'] = (dataContact['requireFac'] == null) ? false : dataContact['requireFac'];

    bool res = await emDataServer.sendDataContact(dataContact, this._tokenServer);

    dataContact = null;
    if(!res) {
      setState(() {
        this._showError = true;
        this._inProceso = false;
      });
    }else{
      this._procesos[this._initProceso]['hecho'] = true;
      tdsSng.idTd = emDataServer.result['body'];
      this._inProceso = false;
      return res;
    }
    return false;
  }

  ///
  Future<bool> _sendDataLinks() async {
    
    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Datos de Enlaces';
    });
    this._initProceso = 'dataLinks';
    if(this._procesos[this._initProceso]['hecho']){ return true; }
    this._inProceso = true;
    Map<String, dynamic> dataLink = tdsSng.toJsonDataLinks();
    dataLink['idTd'] = tdsSng.idTd;
    bool res = await emDataServer.sendDataLinks(dataLink, this._tokenServer);
    dataLink = null;
    if(!res) {
      setState(() {
        this._showError = true;
        this._inProceso = false;
      });
    }else{
      this._procesos[this._initProceso]['hecho'] = true;
      this._inProceso = false;
      return res;
    }
    return false;
  }

  ///
  Future<bool> _sendDataDisenio() async {

    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Datos del Diseño';
    });
    this._initProceso = 'dataDisenio';
    if(this._procesos[this._initProceso]['hecho']){ return true; }
    this._inProceso = true;
    Map<String, dynamic> dataDisenio = tdsSng.toJsonDataDisenio();
    dataDisenio['idTd'] = tdsSng.idTd;
    bool res = await emDataServer.sendDataDisenio(dataDisenio, this._tokenServer);
    dataDisenio = null;
    if(!res) {
      setState(() {
        this._showError = true;
        this._inProceso = false;
      });
    }else{
      this._procesos[this._initProceso]['hecho'] = true;
      tdsSng.idDisenio = emDataServer.result['body'];
      this._inProceso = false;
      return res;
    }
    return false;
  }

  ///
  Future<bool> _sendDataFotoUno() async {

    await _reestructurarIdsParaImagenes();
    this._initProceso = 'dataFotoUno';
    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Enviando Foto 1';
    });
    this._inProceso = true;
    Map prueba = new Map();
    try {
      prueba = tdsSng.lstFotos[0];
    } catch (e) {
      this._inProceso = false;
      return true;
    }
    if(prueba.isNotEmpty) {
      return await _enviarFotoNum(0);
    }
    return false;
  }

  ///
  Future<bool> _sendDataFotoDos() async {

    this._initProceso = 'dataFotoDos';
    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Enviando Foto 2';
    });
    this._inProceso = true;
    Map prueba = new Map();
    try {
      prueba = tdsSng.lstFotos[1];
    } catch (e) {
      this._inProceso = false;
      return true;
    }
    if(prueba.isNotEmpty) {
      return await _enviarFotoNum(1);
    }
    return false;
  }

  ///
  Future<bool> _sendDataFotoTres() async {

    this._initProceso = 'dataFotoTre';
    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Enviando Foto 3';
    });
    this._inProceso = true;
    Map prueba = new Map();
    try {
      prueba = tdsSng.lstFotos[2];
    } catch (e) {
      this._inProceso = false;
      return true;
    }
    if(prueba.isNotEmpty) {
      return await _enviarFotoNum(2);
    }
    return false;

  }

  ///
  Future<bool> _sendDataFotoCuatro() async {

    this._initProceso = 'dataFotoCuatro';
    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Enviando Foto 4';
    });
    this._inProceso = true;
    Map prueba = new Map();
    try {
      prueba = tdsSng.lstFotos[3];
    } catch (e) {
      this._inProceso = false;
      return true;
    }
    if(prueba.isNotEmpty) {
      return await _enviarFotoNum(3);
    }
    return false;
  }

  ///
  Future<bool> _enviarFotoNum(int index) async {

    bool res = await emDataServer.sendDataFoto(
      dataFoto: tdsSng.lstFotos[index],
      idTd: tdsSng.idTd,
      tokenServer: this._tokenServer
    );

    if(!res) {
      setState(() {
        this._showError = true;
        this._inProceso = false;
      });
    }else{
      this._procesos[this._initProceso]['hecho'] = true;
      this._inProceso = false;
      this._fotosNombres.add( emDataServer.result['body'] );
      return res;
    }

    return false;
  }

  ///
  Future<bool> _sendDataNombresDeFotos() async {

    this._initProceso = 'dataFotosNombre';
    if(this._inProceso){ return false; }
    setState(() {
      this._haciendo = 'Finalizando proceso';
    });
    this._inProceso = true;
    if(this._procesos[this._initProceso]['hecho']){ return true; }

    bool res = await emDataServer.sendDataNombresFotos(this._fotosNombres, tdsSng.idDisenio, this._tokenServer);
    if(!res) {
      setState(() {
        this._showError = true;
      });
    }else{
      this._procesos[this._initProceso]['hecho'] = true;
      this._inProceso = false;
      return res;
    }

    return false;
  }

  ///
  Future<void> _reestructurarIdsParaImagenes() async {

    if(tdsSng.lstFotos.length > 0) {
      for (var i = 0; i < tdsSng.lstFotos.length; i++) {
        tdsSng.lstFotos[i]['id'] = (i+1);
      }
    }else{
      setState(() {
        this._haciendo = 'Listo Redireccionando';
      });
      _listoFin();
    }
  }

  ///
  Future<void> _listoFin() async {
    await emRoto.deleteProceso();
    tdsSng.dispose();
    Navigator.of(this._context).pushNamedAndRemoveUntil('index_ctrl', (route) => false);
  }

}