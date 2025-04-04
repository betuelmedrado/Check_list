
import 'package:cloud_firestore/cloud_firestore.dart';


Future<Map<String,dynamic>> getFriends(String uidUser) async{

  Map<String,dynamic> friends = {};

  final getData = await FirebaseFirestore.instance.collection('user').doc(uidUser).get();

  List getFriends = getData['friends'];

  friends['friends'] = getFriends;

  return friends ;
}


Future<List> listFriends(String uidUser) async{

  Map<String, dynamic> emailPhoneFriends = await getFriends(uidUser);
  List lista = [];
  List uidListFriends = [];


  for(Map itens in emailPhoneFriends['friends']){

    uidListFriends.add(itens['uid']);
    }

  final content = await FirebaseFirestore.instance.collection('user').get();

  for (var data in content.docs) {

    if(uidListFriends.contains(data.data()['uid'])){
      lista.add(data.data());
    }
  }

  return lista;
}

