

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// imports pages
import 'package:check_list/pages/addItens.dart';

class ScreenList extends StatefulWidget {

  String uid;
  String namePerfil;
  String uid_purchased;
  final image;

  ScreenList(this.uid, this.namePerfil, this.uid_purchased,{this.image, super.key});


  @override
  State<ScreenList> createState() => _ScreenListState();
}


class _ScreenListState extends State<ScreenList> {

  List lista = [];

  @override
  void initState(){
    super.initState();

    updateProducts();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('Produtos'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          TextButton(onPressed: (){deleteAll();}, child: const Icon(Icons.cleaning_services_rounded)),
          TextButton(onPressed: (){sortList();}, child: const Icon(Icons.refresh))],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom:20.0),
              child: Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: widget.image != null ? NetworkImage(widget.image) : const AssetImage('assets/img/placeholder.png'),
                ),
              ),
            ),
            Text(widget.namePerfil, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),),

            Expanded(
              child: ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index){
                    return Padding(
                        padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 10.0),
                        child: Dismissible(
                          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                          onDismissed:(file){
                            deleteProducts(index);
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color:Colors.red,
                              borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.delete_forever, size:50.0),),
                          child: CheckboxListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              value: lista[index]['Ok'],
                              title: Text('${lista[index]['Products']}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20.0)),
                              subtitle: Text('Comprado: ${lista[index]['purchased'] ?? ''}'),
                              tileColor: Colors.yellow,
                              secondary:const Icon(Icons.panorama_outlined, size: 80.0,),
                              onChanged:(task){
                                print('TASKk $task');
                                lista[index]['Ok'] = task;

                                if(task == true ){
                                  lista[index]['purchased'] = widget.namePerfil;
                                  lista[index]['uid_purchased'] = widget.uid_purchased;
                                }else if(task == false && lista[index]['uid_purchased'] != widget.uid_purchased ){
                                  task = true;
                                  lista[index]['Ok'] = task;
                                  purchased_check();
                                  return;
                                }else{
                                  lista[index]['purchased'] = null;
                                }
                                saveList();

                              }),
                        )
                    );
                  }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed:(){
            addItens();
          },
          child: const Icon(Icons.add)),
    );
  }

  void addItens(){

    Navigator.push(context, MaterialPageRoute(builder: (context) => AddItens(widget.uid)));
  }

  void updateProducts() async{

    FirebaseFirestore.instance.collection('user').doc(widget.uid).snapshots().listen((products){
      setState(() {
        lista = [];
        products.data()?['products'].forEach((data){
          lista.add(data);
        });
      });
    });
  }

  void deleteAll(){
    List beckupList = lista;

    if(widget.uid == widget.uid_purchased){
      setState(() {
        lista.clear();
        saveList();
      });
    }

  }

  void deleteProducts(int index){

    final productDeleted = lista.removeAt(index);
    FirebaseFirestore.instance.collection('user').doc(widget.uid).update({'products': lista});
    deletedMessenget(index, productDeleted);

  }

  void deletedMessenget(int index, Map<String, dynamic> product){

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item deletado!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.yellow,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.black,
          onPressed: (){
            lista.insert(index, product);

            FirebaseFirestore.instance.collection('user').doc(widget.uid).update({'products': lista});

          },
        ),
      )
    );

  }

  void purchased_check(){

    showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          content: const SizedBox(
            width: 100.0,
            height: 140.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber,size: 50.0, color: Colors.red),
                Text('Você não pode desmarcar essa celeção, só quem marcou pode desmarca-la')
              ],
            )),
        );
      });

  }

  void saveList() async{
    await FirebaseFirestore.instance.collection('user').doc(widget.uid).update({'products':lista});
  }

  void sortList(){

    setState(() {
      // ordena a lista com forme esteja marcado como true e false
      lista.sort((a, b) {
        print('$a == $b');

        if(a['Ok'] && !b['Ok']) {
          return 1;
        } else if(!a['Ok'] && b['Ok']) return -1;
        else return 0;
      });
    });
    saveList();
  }

}
