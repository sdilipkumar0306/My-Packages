import 'dart:convert';

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
import 'package:our_zone/util/widgets_ui/chat_screen_widgets.dart';
import 'chatting_page.dart';
import 'search_user_ui.dart';

class UserChatListUI extends StatefulWidget {
  const UserChatListUI({Key? key}) : super(key: key);

  @override
  _UserChatListUIState createState() => _UserChatListUIState();
}

class _UserChatListUIState extends State<UserChatListUI> {
  Size size = const Size(0.0, 0.0);
  bool isAnyChatSelected = false;
  bool isAchivedClicked = false;
  Stream<QuerySnapshot<Map<String, dynamic>>> snapShot = FirebaseFirestore.instance
      .collection(FbC.user)
      .doc(UserData.primaryUser?.userID)
      .collection(FbC.chats)
      .orderBy(MsgConst.lastMsgTime, descending: true)
      .snapshots();

  List<IconData> chatScreenIcons = [
    Icons.push_pin,
    Icons.delete,
    Icons.volume_off,
    Icons.archive,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: isAnyChatSelected
          ? AppBar(
              backgroundColor: UiConstants.myColor,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    chatScreenIcons.length,
                    (index) => ChatScreenIcons(
                          icon: chatScreenIcons.elementAt(index),
                          onpressed: () {
                            callFunction(index);
                          },
                        )),
              ),
              actions: [
                ChatScreenIcons(icon: Icons.more_vert_rounded, onpressed: () {}),
              ],
              leading: ChatScreenIcons(
                  icon: Icons.close_outlined,
                  onpressed: () {
                    isAnyChatSelected = false;
                    for (var i = 0; i < UserData.userChatList.length; i++) {
                      UserData.userChatList[i].isSelected = false;
                    }
                    if (!mounted) return;
                    setState(() {});
                  }),
            )
          : AppBar(
              backgroundColor: UiConstants.myColor,
              title: Text(
                UserData.primaryUser?.name ?? UiConstants.appName,
                style: const TextStyle(color: UiConstants.appBarElementsColor),
              ),
              centerTitle: true,
              actions: [
                PopupMenuButton(
                  color: UiConstants.appBarElementsColor,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: UiConstants.appBarElementsColor,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [const Icon(Icons.archive), const SizedBox(width: 2), Text(isAchivedClicked ? "Hide Achived" : "Show Achived")],
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: const [Icon(Icons.logout_outlined), SizedBox(width: 2), Text("Logout")],
                      ),
                      value: 2,
                    )
                  ],
                  onSelected: (index) async {
                    if (index == 1) {
                      isAchivedClicked = !isAchivedClicked;
                      if (!mounted) return;
                      setState(() {});
                    } else {
                      await AuthService().signOut();
                      SPS.clear();
                      UserData.primaryUser = null;
                      UserData.secondaryUser = null;
                      UserData.userChatList.clear();
                      UserData.usersChatCount.clear();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInRegisterUI()));
                    }
                  },
                ),
              ],
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu, color: UiConstants.appBarElementsColor),
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
              stream: snapShot,
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  snapShot.data?.docs;
                  onLoadingFunction(snapShot.data?.docs);
                  int length = isAchivedClicked ? UserData.userChatList.length : UserData.userChatList.where((e) => e.isAchived == false).toList().length;
                  return ListView.builder(
                      itemCount: length,
                      itemBuilder: (context, index) {
                        return lcChatTile(index);
                      });
                } else if (snapShot.hasError) {
                  return ListView.builder(
                      itemCount: UserData.userChatList.length,
                      itemBuilder: (context, index) {
                        return lcChatTile(index);
                      });
                } else {
                  return ListView.builder(
                      itemCount: UserData.userChatList.length,
                      itemBuilder: (context, index) {
                        return lcChatTile(index);
                      });
                }
              }),
        ),
      ),
    );
  }

  Widget lcChatTile(int index) {
    int count = (UserData.usersChatCount.map((e) => e.userUID).contains(UserData.userChatList.elementAt(index).userId))
        ? UserData.userChatList.elementAt(index).msgCount -
            UserData.usersChatCount.firstWhere((e) => e.userUID == UserData.userChatList.elementAt(index).userId).messageCount
        : 0;
    return ChatScreenTile(
      index: index,
      count: count,
      onTap: () async {
        onTapFunction(index);
      },
      onlongpress: () {
        onPressFunction(index);
      },
    );
  }

  void onLoadingFunction(List<QueryDocumentSnapshot<Object?>>? queryData) {
    List<UserChatList> lcUserChatList = List<UserChatList>.empty(growable: true);
    for (var i = 0; i < (queryData?.length ?? 0); i++) {
      dynamic tempdata = queryData?[i].data();
      UserChatList lUCD = UserChatList.parseResponse(tempdata);
      lcUserChatList.add(lUCD);
      if (UserData.userChatList.isEmpty) {
        UserData.userChatList.add(lUCD);
        UserData.usersChatCount.add(UserChatCount(lUCD.userId, 0));
      } else {
        if (!UserData.usersChatCount.map((e) => e.userUID).contains(lUCD.userId)) {
          UserData.userChatList.add(lUCD);
          UserData.usersChatCount.add(UserChatCount(lUCD.userId, 0));
        } else if (UserData.userChatList.firstWhere((e) => e.userId == lUCD.userId).lastMsg != lUCD.lastMsg) {
          UserData.userChatList.firstWhere((e) => e.userId == lUCD.userId).lastMsg = lUCD.lastMsg;
          UserData.userChatList.firstWhere((e) => e.userId == lUCD.userId).lastMsgTime = lUCD.lastMsgTime;
          UserData.userChatList.firstWhere((e) => e.userId == lUCD.userId).msgCount = lUCD.msgCount;
        } else {
          int lcCount = UserData.userChatList.elementAt(i).seenMsgCount;
          int lcCount2 = UserData.usersChatCount.firstWhere((e) => e.userUID == UserData.userChatList.elementAt(i).userId).messageCount;
          if (lcCount > lcCount2) {
            UserData.usersChatCount.firstWhere((e) => e.userUID == UserData.userChatList.elementAt(i).userId).messageCount = lcCount;
          }
        }
      }
    }
    if (lcUserChatList.length != UserData.userChatList.length) {
      List<String> tempIds =
          UserData.userChatList.map((e) => e.userId).toList().toSet().difference(lcUserChatList.map((e) => e.userId).toList().toSet()).toList();
      for (var j in tempIds) {
        UserData.userChatList.removeWhere((e) => e.userId == j);
      }
    }
    UserData.userChatList.sort((a, b) => b.lastMsgTime.compareTo(a.lastMsgTime));

    UserData.userChatList.sort((a, b) {
      return (b.isAchived) ? -1 : 1;
    });
    UserData.userChatList.sort((a, b) {
      return (b.isAchived) ? -1 : 1;
    });
    UserData.userChatList.sort((a, b) {
      return (b.isPinned) ? 1 : -1;
    });

    saveUserChat();
  }

  Future<void> onTapFunction(int index) async {
    if (isAnyChatSelected) {
      if (UserData.userChatList.elementAt(index).isSelected) {
        UserData.userChatList.elementAt(index).isSelected = false;
      } else {
        UserData.userChatList.elementAt(index).isSelected = true;
      }
      if (!UserData.userChatList.map((e) => e.isSelected).toList().contains(true)) {
        isAnyChatSelected = false;
      }
      if (!mounted) return;
      setState(() {});
    } else {
      FBUser? user = await DatabaseMethods().getUserDetails(UserData.userChatList.elementAt(index).userId);
      if (user != null) {
        setMessagesCount(UserData.userChatList.elementAt(index).userId, UserData.userChatList.elementAt(index).msgCount);
        UserData.secondaryUser = user;
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatMainUI()));
        if (!mounted) return;
        setState(() {});
      }
    }
  }

  void onPressFunction(int index) {
    isAnyChatSelected = true;
    UserData.userChatList.elementAt(index).isSelected = true;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> setMessagesCount(String id, int value) async {
    if (!await SPS.isPresent(id)) {
      SPS.setvalue(id, value);
    }
  }

  void saveUserChat() {
    List<Map> data = List<Map>.empty(growable: true);
    for (var i in UserData.userChatList) {
      data.add(i.saveUserChat());
    }
    String convertedData = jsonEncode(data);
    SPS.setvalue("user_chat_list", convertedData);
  }

  void pinnedFunction() {
    List<String> userIds = UserData.userChatList.where((e) => e.isSelected == true).map((e) => e.userId).toList();
    for (var i in userIds) {
      if (UserData.userChatList.firstWhere((e) => e.userId == i).isPinned == true) {
        SPS.setUserChatprop(i, false, 1);
        UserData.userChatList.firstWhere((e) => e.userId == i).isPinned = false;
      } else {
        SPS.setUserChatprop(i, true, 1);
        UserData.userChatList.firstWhere((e) => e.userId == i).isPinned = true;
        SPS.setUserChatprop(i, false, 3);
        UserData.userChatList.firstWhere((e) => e.userId == i).isAchived = false;
      }
    }
    for (var i = 0; i < UserData.userChatList.length; i++) {
      UserData.userChatList[i].isSelected = false;
    }
    isAnyChatSelected = false;

    if (!mounted) return;
    setState(() {});
  }

  void mutedFunction() {
    List<String> userIds = UserData.userChatList.where((e) => e.isSelected == true).map((e) => e.userId).toList();
    for (var i in userIds) {
      if (UserData.userChatList.firstWhere((e) => e.userId == i).isMuted == true) {
        SPS.setUserChatprop(i, false, 2);
        UserData.userChatList.firstWhere((e) => e.userId == i).isMuted = false;
      } else {
        SPS.setUserChatprop(i, true, 2);
        UserData.userChatList.firstWhere((e) => e.userId == i).isMuted = true;
      }
    }
    for (var i = 0; i < UserData.userChatList.length; i++) {
      UserData.userChatList[i].isSelected = false;
    }
    isAnyChatSelected = false;

    if (!mounted) return;
    setState(() {});
  }

  void achivedFunction() {
    List<String> userIds = UserData.userChatList.where((e) => e.isSelected == true).map((e) => e.userId).toList();
    for (var i in userIds) {
      if (UserData.userChatList.firstWhere((e) => e.userId == i).isAchived == true) {
        SPS.setUserChatprop(i, false, 3);
        UserData.userChatList.firstWhere((e) => e.userId == i).isAchived = false;
      } else {
        SPS.setUserChatprop(i, true, 3);
        UserData.userChatList.firstWhere((e) => e.userId == i).isAchived = true;
        SPS.setUserChatprop(i, false, 1);
        UserData.userChatList.firstWhere((e) => e.userId == i).isPinned = false;
      }
    }
    for (var i = 0; i < UserData.userChatList.length; i++) {
      UserData.userChatList[i].isSelected = false;
    }
    isAnyChatSelected = false;

    if (!mounted) return;
    setState(() {});
  }

  void deletionFunction() {
    List<String> userIds = UserData.userChatList.where((e) => e.isSelected == true).map((e) => e.userId).toList();
    for (var i in userIds) {
      DatabaseMethods().deleteChat(i);
      SPS.removeUserChatprop(i);
      UserData.userChatList.removeWhere((e) => e.userId == i);
      UserData.usersChatCount.removeWhere((e) => e.userUID == i);
    }
    for (var i = 0; i < UserData.userChatList.length; i++) {
      UserData.userChatList[i].isSelected = false;
    }
    isAnyChatSelected = false;

    if (!mounted) return;
    setState(() {});
  }

  void callFunction(int index) {
    switch (index) {
      case 0:
        pinnedFunction();
        break;
      case 1:
        deletionFunction();
        break;
      case 2:
        mutedFunction();
        break;
      case 3:
        achivedFunction();
        break;
      default:
        () {};
    }
  }
}
