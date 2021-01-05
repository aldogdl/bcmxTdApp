import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BgSkyWidget extends StatelessWidget {

  final anguloGradient;

  BgSkyWidget({Key key, this.anguloGradient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: Color(0xff0070B3).withAlpha(100),
       systemNavigationBarColor: Color(0xffFFFFFF),
       systemNavigationBarIconBrightness: Brightness.dark
    ));
    
    List<Color> colores = [
      const Color(0xff0070B3).withAlpha(100),
      const Color(0xffFFFFFF)
    ];

    if(this.anguloGradient == 'bt') {
      colores = [
        const Color(0xffFFFFFF),
        const Color(0xff0070B3).withAlpha(100)
      ];
    }

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colores,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
    );
  }
}