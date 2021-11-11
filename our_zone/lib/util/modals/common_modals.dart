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

class GetAllUsersResponseData {
  List<FBUser> allusersdata;
  GetAllUsersResponseData({required this.allusersdata});
  factory GetAllUsersResponseData.parseAllUsersDataResponse(List<dynamic> data) {
    return GetAllUsersResponseData(allusersdata: data.map((e) => FBUser.parseResponse(e)).toList());
  }
}

class MainpageChatModal {
  String userID;
  String name;
  String email;
  String profileImage;
  String lastMessage;
  String lastMessageTime;
  int msgCount;

  MainpageChatModal({
    required this.userID,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.msgCount,
  });
}
