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

  AllUsersData({
    required this.userName,
    required this.email,
    required this.id,
  });

  factory AllUsersData.response(dynamic data) {
    return AllUsersData(
      userName: data["user_name"],
      email: data["email"],
      id: data["user_uid"],
    );
  }
}
