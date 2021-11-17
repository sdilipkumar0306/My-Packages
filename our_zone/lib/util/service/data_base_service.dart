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
  Future<String?> createMessage(MessageModal data, int msgCount) async {
    MessageModal primaryMsg = data;
    MessageModal secondaryMsg = data;
    // saving msg in primary user side
    DocumentReference response = await getInstance(pUID, sUID).collection(FbC.messages).add(primaryMsg.createMessageMap());
    secondaryMsg.messageID = response.id;
    // saving msg on secondary user side with msgId of primary inserted msg id
    DocumentReference secondaryresponse = await getInstance(sUID, pUID).collection(FbC.messages).add(secondaryMsg.createMessageMap());
    primaryMsg.messageSecondaryID = secondaryresponse.id;
    SetOptions options = SetOptions(mergeFields: [MsgConst.messageSecondaryID]);
    await getInstance(pUID, sUID).collection(FbC.messages).doc(response.id).set(primaryMsg.createMessageMap(), options);
    UserChatList plastMsgDetails = UserChatList(
      userId: sUID,
      userName: UserData.secondaryUser?.name ?? "",
      profileImage: UserData.secondaryUser?.profileImage ?? "",
      lastMsg: data.messageContent,
      lastMsgTime: data.messageSentTime,
      msgCount: msgCount,
      seenMsgCount: msgCount,
    );
    setUserChatCount(plastMsgDetails);
  }

  Future<void> setUserChatCount(UserChatList lastMsgDetails) async {
    getInstance(pUID, sUID).set(lastMsgDetails.getuserChatListMap());

    DocumentSnapshot oppData = await getInstance(sUID, pUID).get();
    if (oppData.data() != null) {
      UserChatList opponentSideData = UserChatList.parseResponse(oppData.data());
      opponentSideData = UserChatList(
        userId: opponentSideData.userId,
        userName: opponentSideData.userName,
        lastMsg: lastMsgDetails.lastMsg,
        lastMsgTime: lastMsgDetails.lastMsgTime,
        profileImage: opponentSideData.profileImage,
        msgCount: opponentSideData.msgCount + 1,
        seenMsgCount: opponentSideData.seenMsgCount,
      );
      SetOptions options2 = SetOptions(mergeFields: [MsgConst.lastMsg, MsgConst.lastMsgTime, MsgConst.msgCount]);

      // setting last lsg on secondary user side
      getInstance(sUID, pUID).set(opponentSideData.getuserChatListMap(), options2);
    } else {
      // setting last lsg on secondary user side
      UserChatList opponentSideData = lastMsgDetails;
      opponentSideData.msgCount = 1;
      opponentSideData.userId = pUID;
      opponentSideData.profileImage = UserData.primaryUser?.profileImage ?? "";
      opponentSideData.userName = UserData.primaryUser?.name ?? "";
      opponentSideData.seenMsgCount = 0;
      getInstance(sUID, pUID).set(opponentSideData.getuserChatListMap());
    }

    // setting last lsg on primary user side
  }

  void setPrimaryUserMsgCount(UserChatList msdData) {
    SetOptions options = SetOptions(mergeFields: [MsgConst.lastMsg, MsgConst.lastMsgTime, MsgConst.msgCount, MsgConst.seenMsgCount]);
    getInstance(pUID, sUID).set(msdData.getuserChatListMap(), options);
  }

  Future<void> setSecondaryUserMsgCount(String userId) async {
    SetOptions options = SetOptions(mergeFields: [MsgConst.lastMsg, MsgConst.lastMsgTime, MsgConst.msgCount, MsgConst.seenMsgCount]);
    DocumentSnapshot oppData = await getInstance(userId, pUID).get();

    QuerySnapshot<Map<String, dynamic>> response =
        await getInstance(userId, pUID).collection(FbC.messages).orderBy(MsgConst.messageSentTime, descending: true).get();
    int length = response.docs.length;
    MessageModal lastMsg = MessageModal.response(response.docs.first.data());

    if (oppData.data() != null) {
      UserChatList msdData = UserChatList.parseResponse(oppData.data());
      msdData.lastMsg = lastMsg.messageContent;
      msdData.lastMsgTime = lastMsg.messageSentTime;
      msdData.msgCount = length;
      getInstance(pUID, sUID).set(msdData.getuserChatListMap(), options);
    }
  }

  /// required  createMsgModal
  Future<String?> setMsgSeen(MessageModal msg) async {
    SetOptions setOptions = SetOptions(mergeFields: [MsgConst.messageStatus]);
    DocumentSnapshot<Map<String, dynamic>> isIds = await getInstance(sUID, pUID).collection(FbC.messages).doc(msg.messageID).get();
    if (isIds.data() != null) {
      getInstance(sUID, pUID).collection(FbC.messages).doc(msg.messageID).set(msg.createMessageMap(), setOptions);
    }
  }

  Future<void> deleteChat(String uid) async {
    getInstance(pUID, uid).delete();
    QuerySnapshot data = await getInstance(pUID, uid).collection(FbC.messages).get();
    List<String> ids = data.docs.map((e) => e.id).toList();
    for (var i in ids) {
      getInstance(pUID, uid).collection(FbC.messages).doc(i).delete();
    }
  }

  Future<bool> deleteChatMessages(List<String> pIds, List<String> sIds, bool isForBoth) async {
    for (var i in pIds) {
      await getInstance(pUID, sUID).collection(FbC.messages).doc(i).delete();
    }
    if (isForBoth) {
      for (var i in sIds) {
        await getInstance(sUID, pUID).collection(FbC.messages).doc(i).delete();
      }
    }
    return true;
  }
}
