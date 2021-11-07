class GetAllChatResponse {}

class MainpageChatModal {
  String userID;
  String name;
  String email;
  String profileImage;
  String lastMessage;
  String lastMessageTime;

  MainpageChatModal({
    required this.userID,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  // factory MainpageChatModal.response(dynamic data) {
  //   return MainpageChatModal(
  //     userID: data[],
  //     name: data[],
  //     profileImage: data[],
  //     lastMessage: data[],
  //   );
  // }
}
