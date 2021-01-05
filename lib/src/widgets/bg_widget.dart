import 'package:flutter/material.dart';

class BgWidget extends StatelessWidget {
  const BgWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff0070B3),
              const Color(0xff00FFFF),
              const Color(0xffCEB800),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
    );
  }
}