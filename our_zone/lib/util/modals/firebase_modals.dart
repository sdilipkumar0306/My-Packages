import 'package:our_zone/util/constants/firebase_constants.dart';

class CreateMessageModal {
  String messageContent;
  String messageFrom;
  String messageTo;
  String messageType;
  String messageSentTime;
  String messageID;
  String messageReplayID;
  String chatType;
  String messageStatus;

  CreateMessageModal({
    required this.messageContent,
    required this.messageFrom,
    required this.messageTo,
    required this.messageType,
    required this.messageSentTime,
    required this.messageID,
    required this.messageReplayID,
    required this.chatType,
    required this.messageStatus,
  });

  factory CreateMessageModal.response(dynamic data) {
    return CreateMessageModal(
      messageContent: data[MsgConst.messageContent],
      messageFrom: data[MsgConst.messageFrom],
      messageTo: data[MsgConst.messageTo],
      messageType: data[MsgConst.messageType],
      messageSentTime: data[MsgConst.messageSentTime],
      messageID: data[MsgConst.messageID],
      messageReplayID: data[MsgConst.messageReplayID],
      chatType: data[MsgConst.chatType],
      messageStatus: data[MsgConst.messageStatus],
    );
  }

  Map<String, dynamic> createMessageMap() => {
        MsgConst.messageContent: messageContent,
        MsgConst.messageFrom: messageFrom,
        MsgConst.messageTo: messageTo,
        MsgConst.messageType: messageType,
        MsgConst.messageSentTime: messageSentTime,
        MsgConst.messageID: messageID,
        MsgConst.messageReplayID: messageReplayID,
        MsgConst.chatType: chatType,
        MsgConst.messageStatus: messageStatus,
      };
}

class FBUser {
  String userID;
  String name;
  String email;
  String profileImage;
  String aboutUser;

  FBUser({
    required this.userID,
    required this.name,
    required this.email,
    this.profileImage = "NA",
    this.aboutUser = "NA",
  });

  factory FBUser.parseResponse(dynamic data) {
    return FBUser(
      userID: data[UserConst.userID],
      name: data[UserConst.userName],
      email: data[UserConst.userEmail],
      profileImage: data[UserConst.userProfileImage],
      aboutUser: data[UserConst.aboutUser],
    );
  }

  Map<String, dynamic> createUserData() => {
        UserConst.userName: name,
        UserConst.userID: userID,
        UserConst.userEmail: email,
        UserConst.userProfileImage: profileImage,
        UserConst.aboutUser: aboutUser,
      };
}

class UserChatList {
  String userId;
  String userName;
  String lastMsg;
  String lastMsgTime;
  int msgCount;

  UserChatList({
    required this.userId,
    required this.userName,
    required this.lastMsg,
    required this.lastMsgTime,
    required this.msgCount,
  });

  factory UserChatList.parseResponse(dynamic data) {
    return UserChatList(
      userId: data[UserConst.userID],
      userName: data[UserConst.userName],
      lastMsg: data[MsgConst.lastMsg],
      lastMsgTime: data[MsgConst.lastMsgTime],
      msgCount: data[MsgConst.msgCount],
    );
  }

  Map<String, dynamic> getuserChatListMap() => {
        UserConst.userName: userName,
        MsgConst.lastMsg: lastMsg,
        MsgConst.lastMsgTime: lastMsgTime,
        MsgConst.msgCount: msgCount,
      };
}
