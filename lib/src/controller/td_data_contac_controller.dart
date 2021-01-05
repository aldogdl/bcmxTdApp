import 'package:flutter/material.dart';

import '../widgets/bg_sky_widget.dart';
import '../templates/tdDataContacController/frm_contac.dart';

class TdDataContacController extends StatefulWidget {

  TdDataContacController({Key key}) : super(key: key);

  @override
  _TdDataContacControllerState createState() => _TdDataContacControllerState();
}

class _TdDataContacControllerState extends State<TdDataContacController> {

  GlobalKey<ScaffoldState> _keyScaff = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('index_ctrl');
        return Future.value(true);
      },
      child: Scaffold(
        key: this._keyScaff,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Datos de Contacto',
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
            FrmContac(
              scaffoldParent: this._keyScaff.currentState,
            )
          ],
        ),
      )
    );
  }
}