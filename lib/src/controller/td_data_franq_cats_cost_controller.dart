import 'package:flutter/material.dart';

import '../widgets/bg_sky_widget.dart';
import '../templates/tdDataFranqCatsCostController/frm_franq_cats_cost.dart';

class TdDataFranqCatsCostController extends StatelessWidget {

  TdDataFranqCatsCostController({Key key}) : super(key: key);

  final  GlobalKey<ScaffoldState>_keySkff = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed('td_data_disenio');
        return Future.value(true);
      },
      child: Scaffold(
        key: this._keySkff,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Franquicias, Categorías y Costo',
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 14
            ),
          ),
          backgroundColor: const Color(0xff0070B3),
        ),
        body: Stack(
          children: [
            BgSkyWidget(),
            FrmFranqCatsCost(keySkffParent: this._keySkff.currentState)
          ],
        ),
      )
    );
  }
}