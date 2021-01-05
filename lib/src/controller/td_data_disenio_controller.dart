import 'package:flutter/material.dart';

import '../widgets/bg_sky_widget.dart';
import '../templates/tdDataDisenioController/frm_disenio.dart';

class TdDataDisenioController extends StatelessWidget {

  TdDataDisenioController({Key key}) : super(key: key);

  final  GlobalKey<ScaffoldState>_keySkff = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('td_data_links');
        return Future.value(true);
      },
      child: Scaffold(
        key: this._keySkff,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Diseño de la Tarjeta',
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
            FrmDisenio(
              keySkffParent: this._keySkff.currentState,
            )
          ],
        ),
      )
    );
  }
}