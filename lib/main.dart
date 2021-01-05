import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bcmxtds/config/data_shared.dart';
import 'package:bcmxtds/config/routes_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final RoutesMain _routesMain = RoutesMain();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: Color(0xff002f51).withAlpha(100),
       systemNavigationBarColor: Color(0xff002f51)
    ));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataShared())
      ],
      child: MaterialApp(
        title: 'BcmxTds Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'MX'),
        ],
        initialRoute: 'init_config_ctrl',
        routes: this._routesMain.getRutas(context),
      ),
    );
  }

}
