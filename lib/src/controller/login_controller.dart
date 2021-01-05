import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/bg_widget.dart';
import '../templates/loginController/frm_login.dart';

class LoginController extends StatefulWidget {
  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {

  GlobalKey<ScaffoldState> _skaffKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: Color(0xff0070B3).withAlpha(100),
       systemNavigationBarColor: Color(0xffCEB800),
       systemNavigationBarIconBrightness: Brightness.dark
    ));
    
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        key: this._skaffKey,
        body: Stack(
          children: [
            BgWidget(),
            Center(
              child: FrmLoginWidget(keyScaffoldParent: _skaffKey.currentState),
            )
          ],
        ),
      ),
    );
  }
}