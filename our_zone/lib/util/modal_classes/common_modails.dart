import 'package:our_zone/util/contstants/firebase_constants.dart';

class GetAllUsersResponseData {
  List<AllUsersData> allusersdata;

  GetAllUsersResponseData({required this.allusersdata});

  factory GetAllUsersResponseData.parseAllUsersDataResponse(List<dynamic> data) {
    return GetAllUsersResponseData(allusersdata: data.map((e) => AllUsersData.response(e)).toList());
  }
}

class AllUsersData {
  String userName;
  String email;
  String id;
  String profileImage;

  AllUsersData({
    required this.userName,
    required this.email,
    required this.id,
    required this.profileImage,
  });

  factory AllUsersData.response(dynamic data) {
    return AllUsersData(
      userName: data[UserConstants.userName],
      email: data[UserConstants.userEmail],
      id: data[UserConstants.userID],
      profileImage: data[UserConstants.userProfileImage],
    );
  }
}
