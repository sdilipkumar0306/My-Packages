class HTTPServiceModal {
  final int? code;
  final dynamic msg;

  HTTPServiceModal({this.code, this.msg});

  factory HTTPServiceModal.fromJson(Map<String, dynamic> json) {
    return HTTPServiceModal(code: json['code'] as int, msg: json['msg'] as dynamic);
  }
}

class ResponseData {
  final UserDetails? userDetails;

  ResponseData({this.userDetails});

  factory ResponseData.parseCloudResponse(List<dynamic> data) {
    print("aaaaaaaaaaaaaaaa");
    return ResponseData(userDetails: data[0]);
  }
}

class UserDetails {
  String? name;
  String? email;
  String? password;
  int? dbID;

  UserDetails({this.name, this.email, this.password, this.dbID});
  factory UserDetails.parseResponse(dynamic data) {
    return UserDetails(
      dbID: data[0]["USER_ID"],
      name: data[0]["USER_NAME"],
      email: data[0]["EMAIL_ID"],
      password: data[0]["PASSWORD"],
    );
  }
}
