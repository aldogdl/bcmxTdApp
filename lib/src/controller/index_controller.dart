import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../templates/indexController/index.dart';

class IndexController extends StatelessWidget {
  const IndexController({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff0070B3).withAlpha(100),
      systemNavigationBarColor: Color(0xffFFFFFF),
      systemNavigationBarIconBrightness: Brightness.dark
    ));

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          body: IndexPage(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed('td_data_contac'),
            child: Icon(Icons.add, size: 40),
          ),
        ),
      )
    );
  }
}