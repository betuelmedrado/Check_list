
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// pages imports
import 'package:check_list/home.dart';


class InsertPhone extends StatefulWidget {

  final currentUser;

  const InsertPhone(this.currentUser, {super.key});

  @override
  State<InsertPhone> createState() => _InsertPhoneState();
}


class _InsertPhoneState extends State<InsertPhone> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(Icons.warning, size: 110.0, color: Colors.orange),

            const SizedBox(height:20.0),

            const Text('Insira o seu numero de celular para que seja encontrado pelo seus amigos com mais facilidade!', ),

            const SizedBox(height:100.0),

            Card(
              elevation:11.0,
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  filled: true,
                  label: const Text('Sómente numero'),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0)
                  ),
                ),
              ),
            ),
            const Text('Não coloque o código do pais e nem o (DDD).'),

            const SizedBox(height:50.0),

            Card(
              elevation: 11.0,
              color: const Color.fromARGB(0, 0, 0, 0),
              child: TextButton(
                style:TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                onPressed: (){
                  savePhone();
                },
                child:const Text('Salvar numero', style: TextStyle(color:Colors.white)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text('Inserir numero deposi!'),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (build) => Home(widget.currentUser)) );
            },
          ),
        ],
      ),
    );
  }


  void savePhone(){

    String phoneText = phoneController.text;

    if(phoneText != ''){
      validPhone(phoneText);
    }

  }


  void validPhone(String text) async{

    String phone = text;


    if(phone.length == 9) {
      String numberFirst = text.substring(0, 5);
      String numberEnd = text.substring(5, 9);

      String joiNumber = numberFirst + numberEnd;

      await FirebaseFirestore.instance.collection('user').doc(
          widget.currentUser.uid).update(
          {'number_phone': joiNumber});

      messageSnack('Numero inserido com sucesso!', const Color.fromARGB(100, 050, 680, 100));

      await Navigator.push(context, MaterialPageRoute(builder: (build) => Home(widget.currentUser)) );
      Navigator.pop(context);

    } else if(phoneController.text == ''){
      
      messageSnack('Digite um numero valido ou prossiga na seta ologo a baixo!', const Color.fromARGB(100, 680, 050, 100));

    }else{

      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            content:const SizedBox(
              height: 100.0,
              child: Column(
                children: [
                  Icon(Icons.warning_amber, color: Colors.red, size:60.0),
                  Text('Formato de numero inválido!'),
                ],
              ),
            ),
          );
        });
    }
  }

  void messageSnack(String msg, Color color){

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(msg)),
    );
  }

}
