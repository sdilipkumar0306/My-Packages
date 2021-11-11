import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/screens/login_register_pages/login_register_ui.dart';
import 'package:our_zone/util/constants/conversion.dart';
import 'package:our_zone/util/constants/firebase_constants.dart';
import 'package:our_zone/util/constants/ui_constants.dart';
import 'package:our_zone/util/modals/common_modals.dart';
import 'package:our_zone/util/modals/firebase_modals.dart';
import 'package:our_zone/util/service/auth_service.dart';
import 'package:our_zone/util/service/data_base_service.dart';
import 'package:our_zone/util/service/sharedpreference_service.dart';
import 'package:our_zone/util/static_data.dart';

import 'chatting_page.dart';
import 'search_user_ui.dart';

class UserChatList extends StatefulWidget {
  const UserChatList({Key? key}) : super(key: key);

  @override
  _UserChatListState createState() => _UserChatListState();
}

class _UserChatListState extends State<UserChatList> {
  Size size = const Size(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(UserData.primaryUser?.name ?? UiConstants.appName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              SPS.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInRegisterUI()));
            },
            icon: const Icon(Icons.logout_outlined),
            splashRadius: 10,
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
          splashRadius: 10,
        ),
      ),
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
        child: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchUserUI()));
            },
            icon: const Icon(Icons.message_rounded)),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height - 50,
        child: SizedBox(
          height: size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FbC.user)
                  .doc(UserData.primaryUser?.userID)
                  .collection(FbC.chats)
                  .orderBy(MsgConst.lastMsgTime, descending: true)
                  .snapshots(),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  return ListView.builder(
                      itemCount: snapShot.data?.docs.length,
                      itemBuilder: (context, index) {
                        String oppUid = snapShot.data?.docs[index].id ?? "";
                        dynamic oppName = snapShot.data?.docs[index].data();
                        TimeOfDay time =
                            (TimeOfDay(hour: DateTime.parse(oppName["last_msg_time"]).hour, minute: DateTime.parse(oppName["last_msg_time"]).minute));

                        MainpageChatModal msgdata = MainpageChatModal(
                            userID: oppUid,
                            name: oppName[UserConst.userName],
                            email: "NA",
                            profileImage: "NA",
                            lastMessage: oppName["last_message"],
                            lastMessageTime: DTconversion.timeConversion(time),
                            msgCount: int.parse(oppName["message_count"].toString()));

                        setMessagesCount(msgdata.userID, msgdata.msgCount);

                        if (UserData.usersChatCount.isEmpty) {
                          UserData.usersChatCount.add(UserChatCount(msgdata.userID, msgdata.msgCount));
                        } else if (!UserData.usersChatCount.map((e) => e.userUID).toList().contains(msgdata.userID)) {
                          UserData.usersChatCount.add(UserChatCount(msgdata.userID, msgdata.msgCount));
                        }

                        // getMessagesCount(snapShot.data?.docs.map((e) => e.id).toList() ?? []);

                        return chatListtile(msgdata);
                      });
                } else if (snapShot.hasError) {
                  return const Center(
                      child: SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(),
                  ));
                } else {
                  return const Center(
                      child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ));
                  ;
                }
              }),
        ),
      ),
    );
  }

  Widget chatListtile(MainpageChatModal data) {
    int count = data.msgCount - UserData.usersChatCount.firstWhere((e) => e.userUID == data.userID).messageCount;
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(data.name),
        subtitle: Text(
          data.lastMessage,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
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
            Text(data.lastMessageTime),
            if (count > 0)
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
        onTap: () async {
          FBUser? user = await DatabaseMethods().getUserDetails(data.userID);
          if (user != null) {
            UserData.secondaryUser = user;
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatMainUI()));
            if (!mounted) return;
            setState(() {});
          }

          // await Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ChatMainUI(
          //               opponentData: FBUser(
          //                 name: data.name,
          //                 email: data.email,
          //                 userID: data.userID,
          //                 profileImage: 'NA',
          //               ),
          //             )));
        },
        onLongPress: () {},
      ),
    );
  }

  Future<void> setMessagesCount(String id, int value) async {
    if (!await SPS.isPresent(id)) {
      SPS.setvalue(id, value);
    }
  }
}
