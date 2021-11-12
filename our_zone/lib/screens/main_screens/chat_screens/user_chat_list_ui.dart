import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/screens/login_register_pages/login_register_ui.dart';
import 'package:our_zone/util/constants/conversion.dart';
import 'package:our_zone/util/constants/firebase_constants.dart';
import 'package:our_zone/util/constants/ui_constants.dart';
import 'package:our_zone/util/modals/firebase_modals.dart';
import 'package:our_zone/util/service/auth_service.dart';
import 'package:our_zone/util/service/data_base_service.dart';
import 'package:our_zone/util/service/sharedpreference_service.dart';
import 'package:our_zone/util/static_data.dart';
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
                children: [
                  IconButton(
                    onPressed: () async {
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
                    },
                    icon: const Icon(
                      Icons.push_pin,
                      color: Colors.white,
                    ),
                    splashRadius: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      List<String> userIds = UserData.userChatList.where((e) => e.isSelected == true).map((e) => e.userId).toList();
                      for (var i in userIds) {
                        DatabaseMethods().deleteChat(i);
                        SPS.removeUserChatprop(i);
                        UserData.userChatList.removeWhere((e) => e.userId == i);
                      }
                      for (var i = 0; i < UserData.userChatList.length; i++) {
                        UserData.userChatList[i].isSelected = false;
                      }
                      isAnyChatSelected = false;

                      if (!mounted) return;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    splashRadius: 10,
                  ),
                  IconButton(
                    onPressed: () async {
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
                    },
                    icon: const Icon(
                      Icons.volume_off,
                      color: Colors.white,
                    ),
                    splashRadius: 10,
                  ),
                  IconButton(
                    onPressed: () async {
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
                    },
                    icon: const Icon(
                      Icons.archive,
                      color: Colors.white,
                    ),
                    splashRadius: 10,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () async {},
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  splashRadius: 10,
                ),
              ],
              leading: IconButton(
                onPressed: () {
                  isAnyChatSelected = false;
                  for (var i = 0; i < UserData.userChatList.length; i++) {
                    UserData.userChatList[i].isSelected = false;
                  }
                  if (!mounted) return;
                  setState(() {});
                },
                icon: const Icon(
                  Icons.close_outlined,
                  color: Colors.white,
                ),
                splashRadius: 10,
              ),
            )
          : AppBar(
              backgroundColor: UiConstants.myColor,
              title: Text(
                UserData.primaryUser?.name ?? UiConstants.appName,
                style: const TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await AuthService().signOut();
                    SPS.clear();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInRegisterUI()));
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  splashRadius: 10,
                ),
              ],
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
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
                  // UserData.userChatList.clear();
                  for (var i = 0; i < (snapShot.data?.docs.length ?? 0); i++) {
                    dynamic tempdata = snapShot.data?.docs[i].data();
                    if (UserData.userChatList.isEmpty) {
                      UserData.userChatList.add(UserChatList.parseResponse(tempdata));
                    } else {
                      if ((!UserData.userChatList.map((e) => e.userId).toList().contains(UserChatList.parseResponse(tempdata).userId) ||
                          UserData.userChatList.firstWhere((e) => e.userId == UserChatList.parseResponse(tempdata).userId).lastMsg !=
                              UserChatList.parseResponse(tempdata).lastMsg)) {
                        UserData.userChatList.removeWhere((e) => e.userId == UserChatList.parseResponse(tempdata).userId);
                        UserData.userChatList.add(UserChatList.parseResponse(tempdata));
                      }
                    }
                  }
                  getmsgUiprop();
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
                  // List<UserChatList> lcUserChatList = List<UserChatList>.empty(growable: true);
                  // lcUserChatList.addAll(UserData.userChatList.where((e) => e.isAchived == false).toList());
                  int length = isAchivedClicked ? UserData.userChatList.length : UserData.userChatList.where((e) => e.isAchived == false).toList().length;
                  return ListView.builder(
                      itemCount: length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            chatListtile(index),
                            if (index == length - 1)
                              TextButton(
                                  onPressed: () {
                                    print(UserData.userChatList.map((e) => e.isAchived).toList());
                                    isAchivedClicked = !isAchivedClicked;
                                    if (!mounted) return;
                                    setState(() {});
                                  },
                                  child: Text(isAchivedClicked ? "Hide Achived" : "Show Achived"))
                          ],
                        );
                      });
                } else if (snapShot.hasError) {
                  return ListView.builder(
                      itemCount: UserData.userChatList.length,
                      itemBuilder: (context, index) {
                        return chatListtile(index);
                      });
                } else {
                  return ListView.builder(
                      itemCount: UserData.userChatList.length,
                      itemBuilder: (context, index) {
                        return chatListtile(index);
                      });
                }
              }),
        ),
      ),
    );
  }

  Widget chatListtile(int index) {
    int count = 0;
    return Card(
      elevation: 0,
      child: ListTile(
        selectedTileColor: Colors.grey.shade400,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        selected: UserData.userChatList.elementAt(index).isSelected,
        title: Text(
          UserData.userChatList.elementAt(index).userName,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          UserData.userChatList.elementAt(index).lastMsg,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(color: Colors.black),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DTconversion.getTimeDate(UserData.userChatList.elementAt(index).lastMsgTime)[3],
              style: const TextStyle(color: Colors.black),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              if (UserData.userChatList.elementAt(index).isPinned)
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(Icons.push_pin),
                ),
              if (UserData.userChatList.elementAt(index).isMuted)
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(Icons.volume_off),
                ),
              if (UserData.userChatList.elementAt(index).isAchived)
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(Icons.archive),
                ),
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
            ]),
            const SizedBox()
          ],
        ),
        onTap: () async {
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
              UserData.secondaryUser = user;
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatMainUI()));
              if (!mounted) return;
              setState(() {});
            }
          }
        },
        onLongPress: () {
          isAnyChatSelected = true;
          UserData.userChatList.elementAt(index).isSelected = true;
          if (!mounted) return;
          setState(() {});
        },
      ),
    );
  }

  Future<void> setMessagesCount(String id, int value) async {
    if (!await SPS.isPresent(id)) {
      SPS.setvalue(id, value);
    }
  }

  Future<void> getmsgUiprop() async {
    List<String> ids = UserData.userChatList.map((e) => e.userId).toList();
    for (var i in ids) {
      List<bool> response = await SPS.getUserChatprop(i);
      UserData.userChatList.firstWhere((e) => e.userId == i).isPinned = response[0];
      UserData.userChatList.firstWhere((e) => e.userId == i).isMuted = response[1];
      UserData.userChatList.firstWhere((e) => e.userId == i).isAchived = response[2];
    }

    if (!mounted) return;
    setState(() {});
  }
}
