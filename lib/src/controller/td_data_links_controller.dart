import 'package:flutter/material.dart';

import '../widgets/bg_sky_widget.dart';
import '../templates/tdDataLinksController/frm_links.dart';

class TdDataLinksController extends StatelessWidget {

  TdDataLinksController({Key key}) : super(key: key);

  final  GlobalKey<ScaffoldState>_keySkff = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('td_data_contac');
        return Future.value(true);
      },
      child: Scaffold(
        key: this._keySkff,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Links de Contacto',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 17
            ),
          ),
          backgroundColor: const Color(0xff0070B3),
        ),
        body: Stack(
          children: [
            BgSkyWidget(anguloGradient: 'bt'),
            FrmLinks(
              keySkffParent: this._keySkff.currentState,
            )
          ],
        ),
      )
    );
  }
}