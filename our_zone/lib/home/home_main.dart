// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/chat_screen/search_user_ui.dart';
import 'package:our_zone/chat_screen/user_chats.dart';
import 'package:our_zone/util/contstants/constants.dart';
import 'package:our_zone/util/contstants/firebase_constants.dart';
import 'package:our_zone/login_register_page/login_register_ui.dart';
import 'package:our_zone/util/modal_classes/chat_list_modal.dart.dart';
import 'package:our_zone/util/modal_classes/common_modails.dart';
import 'package:our_zone/util/modal_classes/user_static_data.dart';
import 'package:our_zone/util/services/auth_services.dart';
import 'package:our_zone/util/services/db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  Size size = const Size(0, 0);

  List<MainpageChatModal> allusersdata = List<MainpageChatModal>.empty(growable: true);

  @override
  void initState() {
    setStaticdata();

    super.initState();
  }

  Future<void> setStaticdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString(UserConstants.userID);
    UserData.userdetails = await DatabaseMethods().getUserDetails(uid ?? "");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(UserData.userdetails?.name ?? UiConstants.appName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("user_login_id");

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
                  .doc(UserData.userdetails?.userID)
                  .collection(FbC.chats)
                  .orderBy("last_msg_time", descending: true)
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
                            name: oppName[UserConstants.userName],
                            email: "NA",
                            profileImage: "NA",
                            lastMessage: oppName["last_message"],
                            lastMessageTime: timeConversion(time),
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

          // ListView.builder(
          //     shrinkWrap: true,
          //     padding: const EdgeInsets.only(bottom: 200, top: 5),
          //     scrollDirection: Axis.vertical,
          //     itemCount: allusersdata.length,
          //     itemBuilder: (context, index) {
          //       return chatListtile(index);
          //     }),
        ),
      ),
    );
  }

  Widget chatListtile(
      // {required String title, required String lastText, required int count, required Function(String) response}

      MainpageChatModal data) {
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
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatMainUI(
                        opponentData: AllUsersData(
                          userName: data.name,
                          email: data.email,
                          id: data.userID,
                          profileImage: 'NA',
                        ),
                      )));
          if (!mounted) return;
          setState(() {});
        },
        onLongPress: () {},
      ),
    );
  }

  String timeConversion(TimeOfDay time) {
    String hour = ((time.hour > 12) ? time.hour - 12 : time.hour).toString();
    hour = hour == "0" ? "12" : hour;
    String formate = ((time.hour >= 12) ? "pm" : "am");
    if (hour.length == 1) hour = "0$hour";
    String min = time.minute.toString();
    if (min.length == 1) min = "0$min";
    return "$hour:$min $formate";
  }

  Future<void> setMessagesCount(String id, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(id)) {
      prefs.setInt(id, value);
    }
  }

  void getMessagesCount(List<String> id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var i in id) {
      if (!UserData.usersChatCount.map((e) => e.userUID).toList().contains(i)) UserData.usersChatCount.add(UserChatCount(i, prefs.getInt(i) ?? 0));
    }
    // if (!mounted) return;
    // setState(() {});
  }
}
