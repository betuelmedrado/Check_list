

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// imports functions
import 'package:check_list/utils/functions/getFriends.dart';
import 'package:check_list/utils/functions/myDataFirebase.dart';

// utils
import 'package:check_list/utils/cards.dart';
import 'package:check_list/utils/buttons.dart';

class ListFriends extends StatefulWidget {

  final userCurrent;

  const ListFriends(this.userCurrent, {super.key});

  @override
  State<ListFriends> createState() => _ListFriendsState();
}


class _ListFriendsState extends State<ListFriends> {

  List lista = [];


  // void getListFriends(){
  //
  // }

  @override
  void initState(){
    super.initState();

    getListFriends();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amigos'),
      ),
      body: Column(
        children: [
      Expanded(
      child: FutureBuilder(
        future: getListFriends(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator(),);
            case ConnectionState.none:
              return const Center(child: Text('Sem  conexão'));
            default:
              if(snapshot.hasError){
                return const Center(child: Text('Erro de conexão'));
              }else{
                return ListView.builder(
                itemCount: lista.length,
                itemBuilder:(context, index){
                  return Container(
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.white,
                    child: GestureDetector(
                      onTap: (){
                        BoxInformation(index, lista[index]['displayName'], Uri.decodeComponent(lista[index]['photoURL']));

                      },
                      child: CardsUser(lista[index]['displayName'], false, email: lista[index]['email'], image: lista[index]['photoURL'],phone: lista[index]['number_phone'],)
                    ),
                    ),
                  );
                }
              );
            }
          }
        }
      ),
    ),
        ],
      ),
    );
  }

  Future<List> getListFriends() async{
    lista = await listFriends(widget.userCurrent.uid);
    return lista;
  }


  void BoxInformation(int index, String name, final image){

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            },
              child: const Text('Close'),),
          ],
          content:SizedBox(
            height: 320,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10,),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: image != null ? NetworkImage(image) : null ,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(name,style: const TextStyle(fontSize:24, fontWeight: FontWeight.w800),),
                ),
                Expanded(child: Container()),

                MyButtons('Ocultar Compras', seeProduct, views: false, index: index, color: const Color.fromARGB(110 ,87, 85, 84), color_text: Colors.white,),

                Padding(
                  padding: const EdgeInsets.only(top:10,),
                  child: MyButtons('Visualizar views ',  seeProduct, views: true, index: index ,color: const Color.fromARGB(110 ,87, 85, 84), color_text: Colors.white,),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:10,),
                  child: MyButtons('Deletar',  deletFriends, index: index ,color: Colors.orange,color_text: Colors.black,),
                )



              ],
            ),
          ),
        );
    }
    );
  }


  void seeProduct(index, viewsBool) async {

    Map<String, dynamic> creatPerfil = {};

    try{
      List updateListFriends = [];

      // Geting the uid of friends to entry in the friends_email
      final uidFriends = lista[index]['uid'];

      // list receiving the change

      updateListFriends = lista[index]['friends'];

      //Changing the view of the field friends for him to see
      try {
        lista[index]['friends'][index]['view'] = viewsBool;
        await FirebaseFirestore.instance.collection('user').doc(uidFriends).update(
            {'friends': updateListFriends});

      }catch(e) {
        creatPerfil['email'] = widget.userCurrent.email;
        creatPerfil['phone'] = '';
        creatPerfil['uid'] = widget.userCurrent.uid;
        creatPerfil['view'] = viewsBool;

        updateListFriends.add(creatPerfil);

        await FirebaseFirestore.instance.collection('user').doc(uidFriends).update(
            {'friends': updateListFriends});
      }

        if(viewsBool != false){
          messagenInfo('Essa pessoa agora pode ver os seus produtos', Colors.green);
        }else{
          messagenInfo('Você ocultou seus produtos para essa pessoa!', Colors.green);
        }

    }catch(e){
      messagenInfo('Deu algum erro !',Colors.red);
    }

  }


  void deletFriends(index, viewsBool) async{

    List listUpdate = [];
    final myDataFirebase = await myDataFire(widget.userCurrent.uid);

    listUpdate = myDataFirebase['friends'];
    listUpdate.removeAt(index);

    await FirebaseFirestore.instance.collection('user').doc(widget.userCurrent.uid).update({'friends':listUpdate});
    setState(() {});

    messagenInfo('Deletado com success', Colors.orange);

  }


  void messagenInfo(String msg, Color color){

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color,)
    );
  }


}




