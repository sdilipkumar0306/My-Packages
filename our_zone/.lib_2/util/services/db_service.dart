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

  Future<Map<String, dynamic>> getLastMsg(String uid) async {
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instance
        .collection(FbC.user)
        .doc(UserData.userdetails?.userID)
        .collection(FbC.chats)
        .doc(uid)
        .collection(FbC.messages)
        .orderBy(MsgConst.messageSentTime, descending: true)
        .get();

    return (response.docs.first.data());
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

  Future<String?> createMessage(MessageModal data, int msgCount, String name) async {
    DocumentReference response = await FirebaseFirestore.instance
        .collection(FbC.user)
        .doc(UserData.userdetails?.userID)
        .collection(FbC.chats)
        .doc(data.messageTo)
        .collection(FbC.messages)
        .add(data.createMessageMap());

    data.messageID = response.id;

    FirebaseFirestore.instance
        .collection(FbC.user)
        .doc(data.messageTo)
        .collection(FbC.chats)
        .doc(UserData.userdetails?.userID)
        .collection(FbC.messages)
        .add(data.createMessageMap());
    // if (isFirst) {
    FirebaseFirestore.instance.collection(FbC.user).doc(data.messageTo).collection(FbC.chats).doc(UserData.userdetails?.userID).set({
      UserConstants.userName: UserData.userdetails?.name,
      "last_message": data.messageContent,
      "last_msg_time": data.messageSentTime,
      "message_count": msgCount,
    });
    FirebaseFirestore.instance.collection(FbC.user).doc(UserData.userdetails?.userID).collection(FbC.chats).doc(data.messageTo).set({
      UserConstants.userName: name,
      "last_message": data.messageContent,
      "last_msg_time": data.messageSentTime,
      "message_count": msgCount,
    });
    // }
  }

  String? setMsgSeen(String uid, MessageModal id) {
    // FirebaseFirestore.instance
    //     .collection(FbC.user)
    //     .doc(UserData.userdetails?.userID)
    //     .collection(FbC.chats)
    //     .doc(uid)
    //     .collection(FbC.messages)
    //     .doc(id).set({MsgConst.messageStatus:"SEEN"});
    FirebaseFirestore.instance
        .collection(FbC.user)
        .doc(uid)
        .collection(FbC.chats)
        .doc(UserData.userdetails?.userID)
        .collection(FbC.messages)
        .doc(id.messageID)
        .set(id.createMessageMap());
  }
}
