class CreateMessageModal {
  String messageContent;
  String messageFrom;
  String messageTo;
  String messageType;
  String messageSentTime;
  String messageID;
  String messageReplayID;
  String chatType;

  CreateMessageModal({
    required this.messageContent,
    required this.messageFrom,
    required this.messageTo,
    required this.messageType,
    required this.messageSentTime,
    required this.messageID,
    required this.messageReplayID,
    required this.chatType,
  });
  Map<String, dynamic> createMessageMap() => {
        "message_content": messageContent,
        "message_from": messageFrom,
        "message_to": messageTo,
        "message_type": messageType,
        "message_sent_time": messageSentTime,
        "message_id": messageID,
        "message_replay_id": messageReplayID,
        "chat_type": chatType,
      };
}
