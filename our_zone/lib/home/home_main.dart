// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/chat_screen/search_user_ui.dart';
import 'package:our_zone/chat_screen/user_chats.dart';
import 'package:our_zone/util/contstants/constants.dart';
import 'package:our_zone/util/contstants/message_constants.dart';
import 'package:our_zone/login_register_page/login_register_ui.dart';
import 'package:our_zone/util/modal_classes/chat_list_modal.dart.dart';
import 'package:our_zone/util/modal_classes/common_modails.dart';
import 'package:our_zone/util/modal_classes/user_static_data.dart';
import 'package:our_zone/util/services/auth_services.dart';
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
    if (UserData.messagesList.isEmpty) {
      getchattedmessages();
    } else {
      allusersdata = UserData.messagesList;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(UiConstants.appName),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 200, top: 5),
                    scrollDirection: Axis.vertical,
                    itemCount: allusersdata.length,
                    itemBuilder: (context, index) {
                      return chatListtile(index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatListtile(
      // {required String title, required String lastText, required int count, required Function(String) response}

      int index) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(allusersdata.elementAt(index).name),
        subtitle: Text(allusersdata.elementAt(index).lastMessage),
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
            Text(allusersdata.elementAt(index).lastMessageTime),
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
              // child: Center(
              //   child: Text(
              //     "$count",
              //     style: const TextStyle(fontSize: 14),
              //   ),
              // ),
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
                            userName: allusersdata.elementAt(index).name, email: allusersdata.elementAt(index).email, id: allusersdata.elementAt(index).userID),
                      )));
          getchattedmessages();
        },
        onLongPress: () {},
      ),
    );
  }

  Future<void> getchattedmessages() async {
    await UserData.getUserdetails();
    DocumentSnapshot data = await FirebaseFirestore.instance.collection("messages").doc(UserData.userdetails?.userID).get();
    String details = data.data().toString();
    Object? temp = data.data();
    Map tempData = jsonDecode(jsonEncode(temp));
    List<dynamic> abc = tempData.values.toList();
    for (var i = 0; i < abc.length; i++) {
      String userUID = abc.elementAt(i).toString();
      // QuerySnapshot result = await DatabaseMethods().getUserInfo(userUID);
      // UserDetailsmodal userdetails = UserDetailsmodal.parseResponse(result.docs.map((e) => e.data()).toList().elementAt(0));
      await FirebaseFirestore.instance
          .collection("messages")
          .doc(UserData.userdetails?.userID)
          .collection(userUID)
          .orderBy(MsgConst.messageSentTime, descending: true)
          .get()
          .then((v) {
        TimeOfDay time = (TimeOfDay(
            hour: DateTime.parse(v.docs[0].data()[MsgConst.messageSentTime]).hour, minute: DateTime.parse(v.docs[0].data()[MsgConst.messageSentTime]).minute));

        UserData.messagesList.add(MainpageChatModal(
            userID: userUID,
            name: "userdetails.name",
            profileImage: "userdetails.profileImage",
            lastMessage: v.docs[0].data()[MsgConst.messageContent],
            lastMessageTime: timeConversion(time),
            email: "userdetails.email"));
      });
    }
    allusersdata = UserData.messagesList;
    if (!mounted) return;
    setState(() {});

    // print(temp);
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
