// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  Future<QuerySnapshot<Object?>> getUserInfo(String uid) async {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = await FirebaseFirestore.instance.collection("users").where("user_uid", isEqualTo: uid).snapshots();

    return data.elementAt(0);
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance.collection("users").where('userName', isEqualTo: searchField).get();
  }
}
