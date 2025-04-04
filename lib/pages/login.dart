
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:check_list/home.dart';
import'package:google_sign_in/google_sign_in.dart';

import 'package:check_list/pages/screenPhone.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  User? currentUser;

  @override
  void initState(){
    super.initState();

    init_login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const Text('Assece com Gmail'),
            Center(
              child: SizedBox(
                width: 1000.0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(50 ,13, 59, 94),
                  ),
                  onPressed:(){
                    login();

                  },
                  child: const Image(
                    fit:BoxFit.fill,
                    height: 70.0,
                    image:AssetImage('assets/img/gmail.png')
                  ),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  void init_login() async{

    // see if the user is logged in
    FirebaseAuth.instance.authStateChanges().listen((user){
      currentUser = user;
    });
    
    if(currentUser != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(currentUser)));
    }else{
      login();
    }

  }

  void createProfile() async{

    await FirebaseFirestore.instance.collection('user').doc(currentUser!.uid).set({
      'uid' : currentUser!.uid,
      'displayName': currentUser!.displayName,
      'name' : '',
      'email' : currentUser!.email,
      'friends': [],
      'products': [],
      'number_phone' : null,
      'photoURL' : currentUser!.photoURL,
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil creado com sucesso!'))
    );
    
  }


  void login() async{



    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? accessCountGoogle = await googleSignIn.signIn();

    if(accessCountGoogle != null ){
      final GoogleSignInAuthentication googleAuthenticator = await accessCountGoogle.authentication;

      final AuthCredential accessCredential = GoogleAuthProvider.credential(
        idToken: googleAuthenticator.idToken,
        accessToken: googleAuthenticator.accessToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(accessCredential);

      currentUser = userCredential.user;

      final checkProfile = await FirebaseFirestore.instance.collection('user').doc(currentUser!.uid).get();

      if(checkProfile.data() == null ){
        createProfile();
      }

      // To know if have the phone
      bool state_Phone = await statePhone();

      if(state_Phone == true){

        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(currentUser)));

      }else{
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Home(currentUser)));
        Navigator.push(context, MaterialPageRoute(builder: (context) => InsertPhone(currentUser)));
      }


    }

  }

  Future<bool> statePhone() async{

    final data = await FirebaseFirestore.instance.collection('user').doc(currentUser?.uid).get();

    if(data.exists && data['number_phone'] != null ){

      return true;
    }

    return false;
  }

}
