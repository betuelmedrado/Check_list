

import 'package:flutter/material.dart';

// pages
import 'package:check_list/pages/listFriends.dart';

class DrawerTiles extends StatelessWidget {

  final userCurrent;
  Function func;
  DrawerTiles(this.userCurrent, this.func, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DrawerHeader(
            decoration:BoxDecoration(color: Color.fromARGB(5 ,65, 58, 51)),
            child: Icon(Icons.shopping_cart_outlined, size:100.0, )
        ),
        ListTile(
          leading: const Icon(Icons.face),
          title: const Text('Adicionar amigos',style: TextStyle(fontWeight: FontWeight.w900)),
          onTap: (){
            if(userCurrent != null){
              func(userCurrent!);
            }else {
              // getPerfilGoogle();
              Navigator.pop(context);
            }
          },
        ),

        ListTile(
          leading: const Icon(Icons.line_style),
          title: const Text('Ver lista de amigos',style: TextStyle(fontWeight: FontWeight.w900)),
          onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListFriends(userCurrent)));
          },
        ),

      ],
    );
  }
}
