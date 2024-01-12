import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(data) async {
    FirebaseFirestore.instance.collection("Informations").add(data).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("Informations").snapshots();
  }
}
