import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/bg_sky_widget.dart';
import '../templates/tdDataSendController/view_data_send.dart';
import '../repository/user_repository.dart';
import '../../config/data_shared.dart';

class TdDataSendController extends StatefulWidget {

  TdDataSendController({Key key}) : super(key: key);

  @override
  _TdDataSendControllerState createState() => _TdDataSendControllerState();
}

class _TdDataSendControllerState extends State<TdDataSendController> {

  UserRepository emUser = UserRepository();

  BuildContext _context;
  bool _isInit = false;
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_initWidget);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(!this._isInit) {
      this._isInit = true;
      this._context = context;
      context = null;
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(this._context).pushReplacementNamed('td_data_disenio');
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Resúmen del Registro',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 17
            ),
          ),
          backgroundColor: const Color(0xff0070B3),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(this._context).pushNamedAndRemoveUntil('td_data_send_finish', (route) => false);
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.save),
          tooltip: 'Termina',
        ),
        body: Stack(
          children: [
            BgSkyWidget(anguloGradient: 'bt'),
            ViewDataSend()
          ],
        ),
      )
    );
  }

  ///
  Future<void> _initWidget(_) async {

    String token = await emUser.getTokenServerByUserInLocal();
    if(token.length > 20){
      Provider.of<DataShared>(this._context, listen: false).setTokenServer(token);
    }
    token = null;
  }
}