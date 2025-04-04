

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


// imports pages
import 'package:check_list/pages/widgets_kl_mk_tm.dart';

class AddItens extends StatefulWidget {

  String uid;


  AddItens(this.uid, { super.key});

  @override
  State<AddItens> createState() => _AddItensState();
}

class _AddItensState extends State<AddItens> {

  bool kg = true;
  bool ml = false;
  bool tm = false;

  String? text_msg ;
  String? _imageUrl;

  TextEditingController produtoController = TextEditingController();
  TextEditingController marcaController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController tipoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itens'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right:15.0, left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text('Descrição do produto', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w900),)
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
                  child: produtoController.text != '' ? const Icon(Icons.shopping_cart_outlined, size: 100.0, color: Colors.green) : const Icon(Icons.production_quantity_limits, size: 100.0, color: Colors.red),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom:12.0),
                  child: TextField(
                    controller: produtoController,
                    onChanged: (value){
                      print(produtoController.text);
                      setState(() {

                      });
                    },
                    decoration: const InputDecoration(
                      labelText:'Produto',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom:12.0),
                  child: TextField(
                    controller: tipoController,
                    onChanged: (value){
                      setState(() {

                      });
                    },
                    decoration: const InputDecoration(
                        labelText:'Tipo',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))
                    ),
                  ),
                ),

                TextField(
                  controller: marcaController,
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                    border: OutlineInputBorder(borderRadius:BorderRadius.all(Radius.circular(5.0)))),
                ),

                Padding(
                  padding:const EdgeInsets.only(top: 15.0, bottom:5.0),
                  child: TextField(
                    controller: quantidadeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      hintText: 'Quantidade de produtos',
                    ),
                  ),
                ),

                const Text('Informações de recepientes "kilograma, Litros ou Tamanho"'),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(value: kg, onChanged: (value){
                        setState(() {
                          ml = false;
                          tm = false;
                          kg = true;
                        });
                      }),

                      const Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text('KG', style: TextStyle(fontSize: 20.0),),
                      ),

                      Checkbox(value: ml, onChanged: (value){
                        setState(() {
                          kg = false;
                          tm = false;
                          ml = true;
                        });
                      }),
                      const Padding(
                        padding: EdgeInsets.only(right:20.0),
                        child: Text('ML', style: TextStyle(fontSize: 20.0),),
                      ),

                      Checkbox(value: tm, onChanged: (value){
                        setState(() {
                          kg = false;
                          ml = false;
                          tm = true;
                        });
                      }),
                      const Text('TM', style: TextStyle(fontSize: 20.0),),
                    ],
                  ),
                ),

                kg == true ? TextFieldKg(text_msg) : ml == true ? TextFieldMl(text_msg) : tm == true ? TextFieldTm(text_msg) : Container(),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left:30.0),
        width: 900.0 ,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: (){
            saveProduct();
        },
          child: const Text('Save'),
      ),
      ),
    );
  }

  // Function to obtain image from the network
  // Future<void> _searchImage() async{
  //   final query = produtoController.text;
  //   final url = Uri.parse('https://www.google.com/search?q=?$query');
  //   final response = await http.get(url);
  //
  //   print('RESONSDE ${response.statusCode} ${url}');
  //
  //   if(response.statusCode == 200){
  //     setState(() {
  //       _imageUrl = url.toString();
  //     });
  //   }else{
  //     print('Erro ao buscar image ${response.statusCode}');
  //   }
  // }


  void saveProduct() async{

    List lista = [];
    Map<String, dynamic> products = {};

    products['Products'] = produtoController.text;
    products['Type'] = tipoController.text;
    products['Mark'] = marcaController.text;
    products['Quantity'] = quantidadeController.text;
    products['purchased'] = null;
    products['Kg'] = text_msg;
    products['Ok'] = false;
    products['id_purchased'] = null;

    if(produtoController.text == ''){
      messageSnackBar('Preencha o campo produto', false);
      return;
    }

    try{

      // Read the data of database
      final data = await FirebaseFirestore.instance.collection('user').doc(widget.uid).get();
      lista = data.data()?['products'];
      lista.add(products);

      print('midhere ---');

      // if there is no error then write in data base
      await FirebaseFirestore.instance.collection('user').doc(widget.uid).update({'products': lista});
      messageSnackBar('Produto salvo com success!', true);
      clearFields();

      print('end here ---');

    }  on NoSuchMethodError{

      // if not exist data products in database then only write
      lista.add(products);
      await FirebaseFirestore.instance.collection('user').doc(widget.uid).update({'products': lista});
      messageSnackBar('Produto salvo com success', true);
      clearFields();

    }catch(erro){
      messageSnackBar('Produto não foi salvo', false);

    }
  }


  void clearFields(){
    setState(() {
      produtoController.text = '';
      tipoController.text = '';
      marcaController.text = '' ;
      quantidadeController.text = '';
    });

  }

  void messageSnackBar(msg, type){

    // Snachbar Positivo
    if(type == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$msg'))
      );
    }else {
      // SnackBar Negativo
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$msg', style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w900),),
            backgroundColor: Colors.red,)
      );
    }

  }

}
