class UserDetailsmodal {
  final String userID;
  final String name;
  final String email;
  final String profileImage;
  final String aboutUser;

  UserDetailsmodal({
    required this.userID,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.aboutUser,
  });

  factory UserDetailsmodal.parseResponse(dynamic data) {
    return UserDetailsmodal(
      userID: data["user_uid"],
      name: data["user_name"],
      email: data["email"],
      profileImage: data["profile_image"] ?? "NA",
      aboutUser: data["about"] ?? "NA",
    );
  }
}
