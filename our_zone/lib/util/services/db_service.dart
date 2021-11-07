// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_zone/util/contstants/firebase_constants.dart';
import 'package:our_zone/util/modal_classes/common_modails.dart';
import 'package:our_zone/util/modal_classes/create_message_modal.dart';
import 'package:our_zone/util/modal_classes/firebase_modal.dart';
import 'package:our_zone/util/modal_classes/user_modal.dart';
import 'package:our_zone/util/modal_classes/user_static_data.dart';

class DatabaseMethods {
  String? createUserInFirebase(CreateUser data) {
    try {
      FirebaseFirestore.instance.collection(FbC.user).doc(data.userID).set(data.createDserData());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserDetailsmodal?> getUserDetails(String uid) async {
    UserDetailsmodal? userdata;
    try {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instance.collection(FbC.user).where(UserConstants.userID, isEqualTo: uid).get();
      if (response.docs.isNotEmpty) {
        userdata = UserDetailsmodal.parseResponse(response.docs.first);
      }
      return userdata;
    } catch (e) {
      print(e);
    }
  }

  Future<List<AllUsersData>> getAllUserDetails() async {
    List<AllUsersData> alluserData = List<AllUsersData>.empty(growable: true);
    try {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instance.collection(FbC.user).get();

      GetAllUsersResponseData returnResponse = GetAllUsersResponseData.parseAllUsersDataResponse(response.docs);
      alluserData = returnResponse.allusersdata;

      return alluserData;
    } catch (e) {
      print(e);
      return alluserData;
    }
  }

  String? createMessage(CreateMessageModal data, bool isFirst) {
    print("user idddddddd ${UserData.userdetails?.userID}");
    FirebaseFirestore.instance
        .collection(FbC.user)
        .doc(UserData.userdetails?.userID)
        .collection(FbC.chats)
        .doc(data.messageTo)
        .collection(FbC.messages)
        .add(data.createMessageMap());
    FirebaseFirestore.instance
        .collection(FbC.user)
        .doc(data.messageTo)
        .collection(FbC.chats)
        .doc(UserData.userdetails?.userID)
        .collection(FbC.messages)
        .add(data.createMessageMap());
    if (isFirst) {
      FirebaseFirestore.instance
          .collection(FbC.user)
          .doc(data.messageTo)
          .collection(FbC.chats)
          .doc(UserData.userdetails?.userID)
          .set({"chat": "Started", "isFriend": "REQUESTED"});
      FirebaseFirestore.instance
          .collection(FbC.user)
          .doc(UserData.userdetails?.userID)
          .collection(FbC.chats)
          .doc(data.messageTo)
          .set({"chat": "Started", "isFriend": "REQUESTED"});
    }
  }
}
