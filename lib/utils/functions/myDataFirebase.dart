
import 'package:cloud_firestore/cloud_firestore.dart' ;

Future<Map<String, dynamic>> myDataFire(String uid) async{

  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('user').doc(uid).get() ;

  if(snapshot.exists){
    return snapshot.data() as Map<String, dynamic>;
  }

  return {};
}
