import 'dart:io';

import 'package:flutter/material.dart';
import 'package:check_list/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';

// https://check-list-ed5e7.firebaseapp.com

void main() async{
  // Para garantir que o app inicialize corretamente
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:"AIzaSyBoBN6ARSJpTiW87dc2jDChoDIwiK2GQxo",
      appId:"1:563160812063:android:ab02ab4878b5f22b62a32a",
      messagingSenderId:"563160812063",
      projectId: "check-list-ed5e7",
      storageBucket:"check-list-ed5e7.firebasestorage.app"
    ),
  ) : await Firebase.initializeApp();

  runApp(const MyApp());

  // FirebaseFirestore.instance.collection("user").doc().set({"nome":"maria"});

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}