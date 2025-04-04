

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import functions *******
import 'package:check_list/utils/functions/getFriends.dart';


class AddFriends extends StatefulWidget {

  final User currentUser;

  const AddFriends(this.currentUser, {super.key});

  @override
  State<AddFriends> createState() => _AddFriendsState();
}


class _AddFriendsState extends State<AddFriends> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool phoneClick = true;
  bool emailClick = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body:Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left:10.0, right: 10.0),
            child: Center(
              child: SizedBox(
                height:200.0,
                child: Card(
                  color: const Color.fromARGB(5 ,65, 58, 51),
                  elevation: 2,
                  shadowColor: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        Checkbox(value: phoneClick,
                          onChanged: (valor){
                          phoneClick = valor!;
                          emailClick = !valor;
                          setState(() {
                          });
                          }),
                        Padding(padding: const EdgeInsets.only(left:5.0),
                          child: Text('Phone', style: phoneClick == false ? const TextStyle(fontWeight: FontWeight.w900) : const TextStyle(color: Colors.blue,fontSize: 25.0,fontWeight: FontWeight.w900 ,),),),

                        Checkbox(value: emailClick,
                            onChanged: (valor){
                              emailClick = valor!;
                              phoneClick = !valor;
                              setState(() {
                              });
                              }),
                        Padding(padding: const EdgeInsets.only(left:5.0),
                          child: Text('Email', style: emailClick == false ? const TextStyle(fontWeight: FontWeight.w900) : const TextStyle(color: Colors.blue,fontSize: 25.0,fontWeight: FontWeight.w900 ,),),)

                      ],),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0, right:5.0),
                        child: TextField(
                            controller: phoneClick == true ? phoneController : emailController,
                            keyboardType: phoneClick == true ? TextInputType.phone : TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: phoneClick == true ? 'numero' : 'email',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ),
          Container(
            padding:const EdgeInsets.only(left:15.0, right: 15.0) ,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: const Size(1000.0, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))
              ),

              onPressed: (){
                AddFriends();

              },
              child: Text( phoneClick == true ? 'Adicionar numero' : 'Adicionar Email'   ),
            ),
          ),
        ],
      ),

    );
  }


  Future<Map<String,dynamic>> checkFriends(String text, String modo) async{

    Map<String, dynamic> data = {};
    bool isAlready = false;

    QuerySnapshot dataFirebase = await FirebaseFirestore.instance.collection('user').get();
    List isFriends = await alreadyFrineds();

    // Percorrendo pelos dados do firebase
    for (var file in dataFirebase.docs) {
      // Variable to for of is_friends
      int cont = 0;

      // To verificed is friends
      for(Map friends in isFriends){

        if(friends['friends'][cont][modo] == file[modo]){
          messageSnackBar('Essa pessoa já é seu amigo', Colors.orange);
          isAlready = true;
          continue;
        }
        cont++;
      }

      // getting the email and uid of friends
      if(text == file[modo]){
        data['uid'] = file['uid'];
        data['email'] = file['email'];
      }
    }

    if(isAlready){
      data = {};
      messageSnackBar('Essa pessoa já é seu amigo!', Colors.orange);

    }else{
      if(data['uid'] == null){
        messageSnackBar('Essa pessoa não foi encotrada, verifique corretamente o numero ou o email dela!', Colors.red);
      }
    }

    return data ;
  }


  Future<List> alreadyFrineds() async{
    List isFreindes = [];

    Map get_Friends = await getFriends(widget.currentUser.uid);

    isFreindes.add(get_Friends);

    return isFreindes;

  }


  void AddFriends() async{

    List friends = [];
    String type = '';

    Map<String, dynamic> dataCheckFriends = {};

    // getting the friends data to be updated
    final dataFriends = await getFriends(widget.currentUser.uid);

    friends = dataFriends['friends'];

    if(phoneClick == true){
      dataCheckFriends = await checkFriends(phoneController.text, 'number_phone');
      String uid = dataCheckFriends['uid'];
      String email = dataCheckFriends['email'];
      friends.add({'phone':phoneController.text, 'email': email, 'view' : false, 'uid' : uid});

      if(uid == ''){
        return ;
      }

    }else if(emailClick == true){
      dataCheckFriends = await checkFriends(emailController.text, 'email');
      String uid = dataCheckFriends['uid'];
      friends.add({'email':emailController.text, 'view': false, 'uid' : uid });
      if(uid == ''){
        return ;
      }
    }

    await FirebaseFirestore.instance.collection('user').doc(widget.currentUser.uid).update({"friends" : friends});

    messageSnackBar('Amigo salvo com sucesso com "email" ', Colors.green);

    phoneController.clear();
    emailController.clear();
  }


  void messageSnackBar(String message, Color color){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Text(message),
        )
    );
  }

}
