


import 'package:flutter/material.dart';




class TextFieldKg extends StatefulWidget {

  String? text_msg ;

  TextFieldKg(this.text_msg,{super.key});

  @override
  State<TextFieldKg> createState() => _TextFieldsState();
}

class _TextFieldsState extends State<TextFieldKg> {

  TextEditingController controllerFileds = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:20.0),
      width:100.0,
      child:TextField(
        controller: controllerFileds,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: (text){
          widget.text_msg = controllerFileds.text;

        },
        decoration: const InputDecoration(
            labelText: 'KL',
            border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
        ),
      ),
    );
  }
}



class TextFieldMl extends StatefulWidget {
  String? text_msg ;

  TextFieldMl(this.text_msg,{super.key});

  @override
  State<TextFieldMl> createState() => _TextFieldMlState();
}

class _TextFieldMlState extends State<TextFieldMl> {

  TextEditingController controllerFileds = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:20.0),
      width:100.0,
      child:TextField(
        controller: controllerFileds,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (text){

          widget.text_msg = controllerFileds.text;
        },
        decoration: const InputDecoration(
            labelText: 'Ml',
            border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
        ),
      ),
    );
  }
}



class TextFieldTm extends StatefulWidget {
  String? text_msg ;

  TextFieldTm(this.text_msg,{super.key});

  @override
  State<TextFieldTm> createState() => _TextFieldTmState();
}

class _TextFieldTmState extends State<TextFieldTm> {

  TextEditingController controllerFileds = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:20.0),
      width:300.0,
      child:TextField(
        controller: controllerFileds,
        textAlign: TextAlign.center,
        onChanged: (text){
          widget.text_msg = controllerFileds.text;
        },
        decoration: const InputDecoration(
            labelText: 'Tm',
            border:OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
        ),
      ),
    );
  }
}


