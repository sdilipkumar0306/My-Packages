import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/util/common_service.dart';
import 'package:our_zone/util/contstants/firebase_constants.dart';
import 'package:our_zone/util/data_time_convertipon.dart';
import 'package:our_zone/util/modal_classes/common_modails.dart';
import 'package:our_zone/util/modal_classes/create_message_modal.dart';
import 'package:our_zone/util/modal_classes/user_static_data.dart';
import 'package:our_zone/util/services/db_service.dart';

class ChatMainUI extends StatefulWidget {
  final AllUsersData opponentData;
  const ChatMainUI({required this.opponentData, Key? key}) : super(key: key);

  @override
  _ChatMainUIState createState() => _ChatMainUIState();
}

class _ChatMainUIState extends State<ChatMainUI> {
  Size size = const Size(0, 0);
  TextEditingController message = TextEditingController();
  int msgLength = 0;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
              child: const Center(child: Icon(Icons.person)),
            ),
            const SizedBox(width: 20),
            Text(widget.opponentData.userName),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: const Icon(Icons.more_vert_rounded),
            splashRadius: 10,
          ),
        ],
        leadingWidth: 30,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          splashRadius: 10,
        ),
      ),
      bottomSheet: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: size.width - 50,
              height: 50,
              child: TextFormField(
                controller: message,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions_outlined,
                          size: 30,
                          color: Colors.white,
                        )),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            size: 25,
                            color: Colors.white,
                          )),
                    ),
                    filled: true,
                    fillColor: const Color(0xff111823),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50.0)), borderSide: BorderSide(color: Colors.white)),
                    focusColor: Colors.white,
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(50.0)))),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5),
              width: 45,
              height: 45,
              decoration: BoxDecoration(color: Colors.cyan.shade700, shape: BoxShape.circle),
              child: Center(
                  child: IconButton(
                      onPressed: () {
                        if (message.text.isNotEmpty) {
                          CreateMessageModal newMsg = CreateMessageModal(
                              messageContent: message.text,
                              messageFrom: UserData.userdetails?.userID ?? "",
                              messageTo: widget.opponentData.id,
                              messageType: "TEXT",
                              messageSentTime: DateTime.now().toString(),
                              messageID: "NA",
                              messageReplayID: "NA",
                              chatType: "INDIVIDUAL");
                          message.clear();
                          if (!mounted) return;
                          setState(() {});
                          DatabaseMethods().createMessage(newMsg, msgLength > 0);
                        }
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ))),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height - 50,
        child: GestureDetector(
          onTap: () {
            CommonService.closeKeyboard(context);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 65),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(FbC.user)
                    .doc(UserData.userdetails?.userID)
                    .collection(FbC.chats)
                    .doc(widget.opponentData.id)
                    .collection(FbC.messages)
                    .orderBy(MsgConst.messageSentTime, descending: true)
                    .snapshots(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    return ListView.builder(
                        reverse: true,
                        itemCount: snapShot.data?.docs.length,
                        itemBuilder: (context, index) {
                          msgLength = snapShot.data?.docs.length ?? 0;
                          dynamic mydata = snapShot.data?.docs[index].data();
                          TimeOfDay time = (TimeOfDay(
                              hour: DateTime.parse(mydata[MsgConst.messageSentTime]).hour, minute: DateTime.parse(mydata[MsgConst.messageSentTime]).minute));
                          return MessageTile(
                            message: (mydata != null) ? mydata[MsgConst.messageContent] : "",
                            sendByMe: (mydata[MsgConst.messageFrom]) == UserData.userdetails?.userID ? true : false,
                            time: time,
                          );
                        });
                  } else if (snapShot.hasError) {
                    return const Center(
                        child: SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(),
                    ));
                  } else {
                    return const Center(child: Text("No data Found"));
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget chatListtile({
    required String title,
    required String lastText,
    required int count,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(lastText),
        minLeadingWidth: 50,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
          child: const Center(child: Icon(Icons.person)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateTimeConversion().timeConversion(TimeOfDay.now())),
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
              child: Center(
                child: Text(
                  "$count",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }
}

// class MessageTile extends StatelessWidget {
//   final String message;
//   final bool sendByMe;
//   const MessageTile({required this.message, required this.sendByMe, Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
//       alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: sendByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
//         padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
//         decoration: BoxDecoration(
//             borderRadius: sendByMe
//                 ? const BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomLeft: Radius.circular(23))
//                 : const BorderRadius.only(topLeft: Radius.circular(23), topRight: Radius.circular(23), bottomRight: Radius.circular(23)),
//             color: sendByMe ? Colors.blue : Colors.purple.shade900),
//         child: Text(message,
//             textAlign: TextAlign.start, style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'OverpassRegular', fontWeight: FontWeight.w300)),
//       ),
//     );
//   }
// }

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final TimeOfDay time;

  const MessageTile({required this.message, required this.sendByMe, required this.time, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 0, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top: 17, bottom: 0, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15))
                : const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
            color: sendByMe ? Colors.blue : Colors.purple.shade900),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'OverpassRegular', fontWeight: FontWeight.w300)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                timeConversion(time),
                style: TextStyle(fontSize: 10, color: sendByMe ? Colors.black : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeConversion(TimeOfDay time) {
    String hour = ((time.hour > 12) ? time.hour - 12 : time.hour).toString();
    String formate = ((time.hour >= 12) ? "pm" : "am");
    if (hour.length == 1) hour = "0$hour";
    String min = time.minute.toString();
    if (min.length == 1) min = "0$min";
    return "$hour:$min $formate";
  }
}
