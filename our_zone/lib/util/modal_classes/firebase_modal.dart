class CreateUser {
  String userID;
  String name;
  String email;
  String? profileImage;
  String? aboutUser;

  CreateUser({
    required this.userID,
    required this.name,
    required this.email,
    this.profileImage,
    this.aboutUser,
  });

  Map<String, dynamic> createDserData() => {
        "user_name": name,
        "user_uid": userID,
        "email": email,
        "profile_image": profileImage ?? "NA",
        "about": aboutUser ?? "NA",
      };
}
