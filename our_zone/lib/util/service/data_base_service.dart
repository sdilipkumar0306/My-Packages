import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_zone/util/constants/firebase_constants.dart';
import 'package:our_zone/util/modals/common_modals.dart';
import 'package:our_zone/util/modals/firebase_modals.dart';
import 'package:our_zone/util/static_data.dart';

class DatabaseMethods {
  String pUID = UserData.primaryUser?.userID ?? "";
  String sUID = UserData.secondaryUser?.userID ?? "";

  DocumentReference getInstance(String uid1, String uid2) {
    return FirebaseFirestore.instance.collection(FbC.user).doc(uid1).collection(FbC.chats).doc(uid2);
  }

  String? createUserInFirebase(FBUser data) {
    try {
      FirebaseFirestore.instance.collection(FbC.user).doc(data.userID).set(data.createUserData());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// required secondary userID
  Future<Map<String, dynamic>> getLastMsg() async {
    QuerySnapshot<Map<String, dynamic>> response =
        await getInstance(pUID, sUID).collection(FbC.messages).orderBy(MsgConst.messageSentTime, descending: true).get();
    return (response.docs.first.data());
  }

  /// required UserID
  Future<FBUser?> getUserDetails(String uid) async {
    FBUser? userdata;
    try {
      QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instance.collection(FbC.user).where(UserConst.userID, isEqualTo: uid).get();
      if (response.docs.isNotEmpty) {
        userdata = FBUser.parseResponse(response.docs.first);
      }
      return userdata;
    } catch (e) {
      print(e);
    }
  }

  Future<List<FBUser>> getAllUserDetails() async {
    List<FBUser> alluserData = List<FBUser>.empty(growable: true);
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

  /// required Create Msg modal , present msgCount
  Future<String?> createMessage(CreateMessageModal data, int msgCount) async {
    // saving msg in primary user side
    DocumentReference response = await getInstance(pUID, sUID).collection(FbC.messages).add(data.createMessageMap());
    data.messageID = response.id;
    // saving msg on secondary user side with msgId of primary inserted msg id
    getInstance(sUID, pUID).collection(FbC.messages).add(data.createMessageMap());
    UserChatList lastMsgDetails = UserChatList(
      userId: pUID,
      userName: UserData.primaryUser?.name ?? "",
      profileImage: UserData.primaryUser?.profileImage ?? "",
      lastMsg: data.messageContent,
      lastMsgTime: data.messageSentTime,
      msgCount: msgCount,
    );
    // setting last lsg on secondary user side
    getInstance(sUID, pUID).set(lastMsgDetails.getuserChatListMap());
    lastMsgDetails.userName = UserData.secondaryUser?.name ?? "";
    lastMsgDetails.profileImage = UserData.secondaryUser?.profileImage ?? "";
    lastMsgDetails.userId = sUID;
    // setting last lsg on primary user side
    getInstance(pUID, sUID).set(lastMsgDetails.getuserChatListMap());
  }

  /// required  createMsgModal
  String? setMsgSeen(CreateMessageModal msg) {
    getInstance(sUID, pUID).collection(FbC.messages).doc(msg.messageID).set(msg.createMessageMap());
  }

  Future<void> deleteChat(String uid) async {
    getInstance(pUID, uid).delete();
    QuerySnapshot data = await getInstance(pUID, uid).collection(FbC.messages).get();
    List<String> ids = data.docs.map((e) => e.id).toList();
    for (var i in ids) {
      getInstance(pUID, uid).collection(FbC.messages).doc(i).delete();
    }
  }
}
