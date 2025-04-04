
import 'package:check_list/utils/cards.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:feature_discovery/feature_discovery.dart';

// imports pages and modules
import 'package:check_list/screen_list.dart';
import 'package:check_list/pages/addFriends.dart';
import 'package:check_list/pages/addItens.dart';
import 'package:check_list/utils/drawerTiles.dart';

//imports utisl



class Home extends StatefulWidget {

  final currentUser;

  const Home(this.currentUser, {super.key});


  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? userCurrent;
  List productsCurrentUser = [];
  Map<String,dynamic> mapProductUser = {};

  List user_list = [];
  bool has_products = false;


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // User of initialization
    // await FirebaseAuth.instance.authStateChanges().listen((user){
    //   userCurrent = user;
    // });

    userCurrent = widget.currentUser;
    getMyProducts();
    _getFriends();

  }

  // Future getPerfilGoogle() async{
  //
  //   if(userCurrent != null) return userCurrent;
  //
  //   try {
  //     final GoogleSignInAccount? acessCount = await googleSignIn.signIn();
  //
  //     if (acessCount != null) {
  //       final GoogleSignInAuthentication google_authentication = await acessCount.authentication;
  //
  //       final AuthCredential credential_firebase = GoogleAuthProvider.credential(
  //         idToken: google_authentication.idToken,
  //         accessToken: google_authentication.accessToken,
  //       );
  //
  //       final UserCredential credential_user_firebase = await FirebaseAuth.instance.signInWithCredential(credential_firebase);
  //
  //       final User? firebase_user = credential_user_firebase.user;
  //
  //
  //       return firebase_user;
  //     }
  //   } catch(erro){
  //     print('Error where ${erro}');
  //     return null;
  //   }
  // }

  // Future getUidFirebase() async{
  //   // Geting the uid of google
  //   // final uid_user_main = await getPerfilGoogle();
  //   final uid_user_main = await userCurrent;
  //
  //   if(uid_user_main != null) {
  //     final getUserFirebase = await FirebaseFirestore.instance.collection('user').doc(uid_user_main.uid);
  //   }
  //   return uid_user_main;
  // }

  Future credentialFirebase() async{
    final dataCredential = await FirebaseFirestore.instance.collection('user').doc(userCurrent?.uid).get();
    return dataCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawerTiles(userCurrent, addFriends),
      ),
      appBar:AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
            IconButton(onPressed: (){ ifProducts();}, icon: const Icon(Icons.get_app)),
            IconButton(onPressed: (){
              FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
              setState(() {
                Navigator.pop(context);
              });
            },
              icon: const Icon(Icons.logout))],
      ),
    body: Container(
      // alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10.0, top:30.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Procure pelo nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
            ),
          ),

      // User here ====
      productsCurrentUser.isNotEmpty ?
      SizedBox(
        height:100.0,
        width: 1000.0,
        child:GestureDetector(
          onTap:(){
            goListShoping(widget.currentUser.uid.toString(),
                widget.currentUser.displayName,
                widget.currentUser.uid.toString() ,
                image: widget.currentUser.photoURL, );
          },
          child: CardsUser(widget.currentUser.displayName,
            has_products ,
            email: widget.currentUser.email,
            image: widget.currentUser.photoURL,),
        ),
      ) : Container(),

      const Divider(),

      Expanded(
        child: FutureBuilder(
          future: _getFriends(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return const Center(child:CircularProgressIndicator());
              case ConnectionState.none:
                return const Center(child: Icon(Icons.wifi_off));
              default:
                if(snapshot.hasError){
                  return const Center(child: Icon(Icons.error_outline),);
                }else{
                  return ListView.builder(
                      shrinkWrap: true, // Importante para evitar expandir a lista
                      itemCount: user_list.length,
                      itemBuilder: (context, index){
                        return SizedBox(
                          height:100.0,
                          child:GestureDetector(
                            onTap:(){
                              goListShoping(user_list[index]['uid'], widget.currentUser.displayName, widget.currentUser.uid.toString(), image: user_list[index]['photoURL'] );
                            },
                            child: CardsUser(user_list[index]['name'], ifProductsFriends(index) ,
                                email: user_list[index]['email'],
                                phone: user_list[index]['number_phone'],
                                image: Uri.decodeComponent(user_list[index]['photoURL']),
                            ),
                          ),
                        );
                      },
                    );
                }
            }
          }
      ),
    ),
    ],
    ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blueGrey,
      onPressed: (){
        addItens();
      },
      child: const Icon(Icons.add),
    ),

    );
  }



  Future<List> _getFriends() async{
    // final User uid_perfil = await getUidFirebase();

    List listFriends = [];
    int cont = 0;

    // get user credential in firebase
    final credential_Firebase = await credentialFirebase();

    listFriends = credential_Firebase.data()['friends'];


    // final dataUser = await listFriends(credential_Firebase.data()['uid']);
    final dataUser = await listFriends;
    user_list.clear();

    for(final data in dataUser){

      for(final friend in listFriends){
        if(data['uid'] == friend['uid'] && friend['view'] == true){
          user_list.add(data);

        }
      }
    }

    return user_list;

    // // To save the email as a string and not  as map
    // for(Map iten in friends_email){
    //   lista_email.add(iten['uid']);
    // }
    //
    // for(Map phone in friends_phone){
    //   list_phone.add(phone['uid']);
    // }
    //

    // final dataUser = await FirebaseFirestore.instance.collection('user').get();
    // user_list.clear();


    // "dataUser" is friends data
    // dataUser.docs.forEach((file){
    //
    //   // Here analyze the email friends ****
    //   try {
    //     if (lista_email.contains(file.data()['uid'])) {
    //       if (credential_firebase['friends_email'][cont]['view'] == true) {
    //         user_list.add(file.data());
    //       }
    //     }
    //   }catch(error){
    //     print(error);
    //   }

      // Here analyze the friends phone ****
    //   // if(list_phone.contains(file.data()['uid'] )){
    //   //   try {
    //   //     if (credential_firebase['friends_phone'][cont]['view'] == true) {
    //   //       user_list.add(file.data());
    //   //     }
    //   //   }catch (error){
    //   //     print(error);
    //   //   }
    //   // }
    //   // cont++;
    //
    // });
    //
    // // // Loop com "forEach()"
    // // dataUser.docs.forEach((file){
    // //
    // // });
    // return user_list;
  }

  List unicData(List list_1, List list_2){
    for(Map iten1 in list_1) {
      int cont = 0;

      try {
        for (Map iten2 in list_2) {

          if (iten1['uid'] == iten2['uid']) {
            list_2.removeAt(cont);
          }
          cont++;
        }
      }catch(error){
        print('erros $error');
      }

    }
    list_1.addAll(list_2);
    return list_1;
  }


  // Geting the products of current user
  void getMyProducts() async{
    final uidUser = userCurrent;
    productsCurrentUser.clear();
    mapProductUser = {};

    final data = await FirebaseFirestore.instance.collection('user').doc(uidUser?.uid).get();

    // print('DARTS 00 ${data.data()?['products']}');

    await data.data()?['products'].forEach((product){
      setState(() {
        productsCurrentUser.add(product);
      });
    mapProductUser['products'] = productsCurrentUser;
    });

    setState(() {
      has_products = ifProducts();
    });

    // await FirebaseFirestore.instance.collection('user').doc(uid_user?.uid).snapshots().listen((data){
    //   data.data()?['products'].forEach((produt){});});


  }

  bool ifProducts(){
    bool hasProducts = false;
    List listaLength = [];

    final  products = mapProductUser['products'];

    for(Map product in products){
      if(product['purchased'] == null){
        setState(() {
          listaLength.add(product);
          hasProducts = true;
        });
        return hasProducts;

      }else{
        print('ENTERED IN ELSE');
      }
    }

    return hasProducts ;
  }


  bool ifProductsFriends(int index){

    // List lista_products = user_list['products'];

    try {
      for (Map products in user_list[index]['products']) {
        if (products['purchased'] == null) {
          return true;
        }
      }
    }catch(e){
      return false;
    }
    return false;
  }


  void addItens(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddItens(userCurrent!.uid)));
    // Is Here to actualiza the has_products icon
    getMyProducts();

  }

  void addFriends(User currentUser){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddFriends(currentUser)));
  }

  void goListShoping(String data, String namePerfil, String uidPurchased, {final image}) async{

    final timeaAwait = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenList(data, namePerfil, uidPurchased, image: Uri.decodeComponent(image)) ));

    // Is Here to actualiza the has_products icon
    getMyProducts();
    _getFriends();

  }


}
