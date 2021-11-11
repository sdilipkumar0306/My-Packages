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
      messageContent: data["message_content"],
      messageFrom: data["message_from"],
      messageTo: data["message_to"],
      messageType: data["message_type"],
      messageSentTime: data["message_sent_time"],
      messageID: data["message_id"],
      messageReplayID: data["message_replay_id"],
      chatType: data["chat_type"],
      messageStatus: data["message_status"],
    );
  }

  Map<String, dynamic> createMessageMap() => {
        "message_content": messageContent,
        "message_from": messageFrom,
        "message_to": messageTo,
        "message_type": messageType,
        "message_sent_time": messageSentTime,
        "message_id": messageID,
        "message_replay_id": messageReplayID,
        "chat_type": chatType,
        "message_status": messageStatus,
      };
}
