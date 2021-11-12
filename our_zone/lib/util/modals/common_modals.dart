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

class GetUserChatListResponse {
  List<UserChatList> userChatList;

  GetUserChatListResponse({required this.userChatList});

  factory GetUserChatListResponse.parseUserChatListResponse(List<dynamic> data) {
    return GetUserChatListResponse(userChatList: data.map((e) => UserChatList.parseResponse(e)).toList());
  }
}

