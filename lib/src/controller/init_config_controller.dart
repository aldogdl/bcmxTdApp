import 'package:bcmxtds/config/data_shared.dart';
import 'package:bcmxtds/src/repository/data_server_repository.dart';
import 'package:bcmxtds/src/singletons/franqs_cats_singleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../repository/user_repository.dart';
import '../repository/prosroto_repository.dart';
import '../widgets/bg_widget.dart';
import '../widgets/alerts_varios.dart';
import '../singletons/tds_singleton.dart';

class InitConfigController extends StatefulWidget {
  @override
  _InitConfigControllerState createState() => _InitConfigControllerState();
}

class _InitConfigControllerState extends State<InitConfigController> {

  UserRepository emUser = UserRepository();
  ProsRotoRepository emRotos = ProsRotoRepository();
  TdsSingleton tdsSng = TdsSingleton();
  DataServerRepository emServer = DataServerRepository();

  AlertsVarios alertsVarios = AlertsVarios();
  FranqCatsSng franqCatsSng = FranqCatsSng();

  BuildContext _context;
  bool _isInit = false;
  String _haciendo = 'Inicializando';
  String _tokenServer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_initWidget);
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
    }
    this._context = context;
    context = null;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: const Color(0xff0070B3).withAlpha(100),
       systemNavigationBarColor: const Color(0xffCEB800),
       systemNavigationBarIconBrightness: Brightness.dark
    ));

    return Scaffold(
      body: Stack(
        children: [
          BgWidget(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BCMXTds - PANEL',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${this._haciendo}',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.blue
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///
  Future<void> _initWidget(_) async {

    String rutaGo = '';

    setState(() {
      this._haciendo = 'Revisando Credenciales';
    });

    bool hasCredential = await emUser.hasCredentialsUser();
    if(hasCredential) {
      if(await _checkTokenOfUser()){
        this._tokenServer = await emUser.getTokenServerByUserInLocal();
        Provider.of<DataShared>(this._context, listen: false).setTokenServer(this._tokenServer);

        if(await _getFranquicias()) {
          await _checkarProcesosRotos();
          if(rutaGo.isEmpty) {
            return;
          }
        }else{
          String body = 'No se pudieron recuperar las Franquicias actuales, por favor, reinicia la App.';
          await alertsVarios.entendido(this._context, titulo: 'ERROR', body: body);
          return;
        }
        
      }else{
        // Regresa si hubo un Error en el chequeo del token
        return;
      }

    }else{
      rutaGo = 'login_ctrl';
    }
    Navigator.of(this._context).pushNamedAndRemoveUntil(rutaGo, (route) => false);
  }

  ///
  Future<bool> _checkTokenOfUser() async {

    setState(() {
      this._haciendo = 'Revisando TOKEN';
    });

    this._tokenServer = await emUser.getTokenServerByUserInLocal();

    if(this._tokenServer.length > 20) {
      if(!await _validandoToken()){
        return await _refreshToken();
      }else{
        return true;
      }
    }
    return false;
  }

  ///
  Future<bool> _validandoToken() async {
    setState(() {
      this._haciendo = 'Validando TOKEN';
    });

    return await emUser.checkTokenServer(this._tokenServer);
  }

  ///
  Future<bool> _refreshToken() async {

    setState(() {
      this._haciendo = 'TOKEN CADUCADO, Actualizando.';
    });

    bool updated = await emUser.refreshTokenServer(this._context);
    if(!updated){
      setState(() {
        this._haciendo = 'ERROR, Revisa tu conección WiFi, o reinicia la App.';
      });
      return false;
    }
    return true;
  }

  ///
  Future<bool> _checkarProcesosRotos() async {

    setState(() {
      this._haciendo = 'Checando Procesos Rotos.';
    });

    bool has = await emRotos.hasProceso();
    if(has){
      bool res = await alertsVarios.prosRoto(this._context, proceso: emRotos.result['msg']);
      if(!res){
        await emRotos.deleteProceso();
        Navigator.of(this._context).pushNamedAndRemoveUntil('index_ctrl', (route) => false);
      }else{
        await _recuperarProcesoRoto();
      }
    }else{
      Navigator.of(this._context).pushNamedAndRemoveUntil('index_ctrl', (route) => false);
    }
    return true;
  }

  ///
  Future<void> _recuperarProcesoRoto() async {

    setState(() {
      this._haciendo = 'Recuperando Procesos Rotos.';
    });
    tdsSng.setDataTd(emRotos.result['body']['content']);
    Navigator.of(this._context).pushNamedAndRemoveUntil(emRotos.result['body']['route'], (route) => false);
  }

  ///
  Future<bool> _getFranquicias() async {

    setState(() {
      this._haciendo = 'Recabando Franquicias';
    });

    List<Map<String, dynamic>> franqs = await emServer.getFranquicias(this._tokenServer);
    franqCatsSng.setFranquicias(franqs);
    return true;
  }

}