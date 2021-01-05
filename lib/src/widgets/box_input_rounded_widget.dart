import 'package:flutter/material.dart';

class BoxInputRoundedWidget extends StatelessWidget {

  final Color bg;
  final Widget input;
  final bool hasBorder;
  BoxInputRoundedWidget({Key key, this.bg, this.input, this.hasBorder = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      decoration: BoxDecoration(
        color: this.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
          width: (this.hasBorder) ? 1 : 0
        )
      ),
      child: this.input,
    );
  }
}