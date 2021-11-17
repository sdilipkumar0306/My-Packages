import 'package:our_zone/util/constants/firebase_constants.dart';

import 'firebase_modals.dart';

class OurZoneResponse {
  int code;
  dynamic response;

  OurZoneResponse({
    required this.code,
    required this.response,
  });
}

class UserChatCount {
  String userUID;
  int messageCount;

  UserChatCount(this.userUID, this.messageCount);
}

// *******************************************************************************************
class UserChatMessages {
  String userUID;
  List<MessageModal> message;

  UserChatMessages({
    required this.userUID,
    required this.message,
  });

  // data["message"]

  factory UserChatMessages.response(dynamic data) {
    return UserChatMessages(userUID: data[UserConst.userID], message: GetAllUsersMessageModal.parseAllUsersDataResponse(data["message"]).allMessageModal);
  }

  Map<String, dynamic> getUserMessages() => {UserConst.userID: userUID, "message": message.map((e) => e.createMessageMap()).toList()};
}

class GetAllUserChatMessagesList {
  List<UserChatMessages> userChatMessages = List<UserChatMessages>.empty(growable: true);

  GetAllUserChatMessagesList({required this.userChatMessages});
  factory GetAllUserChatMessagesList.parseAllUsersDataResponse(List<dynamic> data) {
    return GetAllUserChatMessagesList(userChatMessages: data.map((e) => UserChatMessages.response(e)).toList());
  }
}
// **********************************************************************************************

class GetAllUsersMessageModal {
  List<MessageModal> allMessageModal;
  GetAllUsersMessageModal({required this.allMessageModal});
  factory GetAllUsersMessageModal.parseAllUsersDataResponse(List<dynamic> data) {
    return GetAllUsersMessageModal(allMessageModal: data.map((e) => MessageModal.response(e)).toList());
  }
}

class GetAllUsersResponseData {
  List<FBUser> allusersdata;
  GetAllUsersResponseData({required this.allusersdata});
  factory GetAllUsersResponseData.parseAllUsersDataResponse(List<dynamic> data) {
    return GetAllUsersResponseData(allusersdata: data.map((e) => FBUser.parseResponse(e)).toList());
  }
}

class GetUserChatListResponse {
  List<UserChatList> userChatList;

  GetUserChatListResponse({required this.userChatList});

  factory GetUserChatListResponse.parseUserChatListResponse(List<dynamic> data) {
    return GetUserChatListResponse(userChatList: data.map((e) => UserChatList.parseResponse(e)).toList());
  }
}
