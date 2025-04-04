
import 'package:flutter/material.dart';



class MyButtons extends StatelessWidget {

  String descrition;
  Function method;
  int? index;
  bool? views;

  final Color color;
  final Color? color_text;

   MyButtons(this.descrition, this.method, {this.views, this.index, this.color_text, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          elevation: 5,
          backgroundColor: color,
          fixedSize: const Size(1000, 50.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed:(){
          method(index, views);
    },
        child: Text(descrition, style: TextStyle(color: color_text, fontSize: 25.0)),
        );
  }
}
