import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/util/constants/conversion.dart';
import 'package:our_zone/util/constants/firebase_constants.dart';
import 'package:our_zone/util/constants/service_constants.dart';
import 'package:our_zone/util/constants/ui_constants.dart';
import 'package:our_zone/util/modals/common_modals.dart';
import 'package:our_zone/util/modals/firebase_modals.dart';
import 'package:our_zone/util/service/data_base_service.dart';
import 'package:our_zone/util/service/sharedpreference_service.dart';
import 'package:our_zone/util/static_data.dart';
import 'package:our_zone/util/widgets_ui/chat_screen_widgets.dart';
import 'package:our_zone/util/widgets_ui/my_alert_box.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatMainUI extends StatefulWidget {
  // final FBUser opponentData;
  const ChatMainUI({Key? key}) : super(key: key);

  @override
  _ChatMainUIState createState() => _ChatMainUIState();
}

class _ChatMainUIState extends State<ChatMainUI> {
  Size size = const Size(0, 0);
  TextEditingController message = TextEditingController();
  int msgLength = 0;
  List<MessageModal> allMsgs = List<MessageModal>.empty(growable: true);
  bool isMsgSelected = false;

  Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshots = FirebaseFirestore.instance
      .collection(FbC.user)
      .doc(UserData.primaryUser?.userID)
      .collection(FbC.chats)
      .doc(UserData.secondaryUser?.userID)
      .collection(FbC.messages)
      .orderBy(MsgConst.messageSentTime, descending: true)
      .snapshots();

  List<IconData> chatScreenIcons = [
    Icons.reply,
    Icons.delete,
    Icons.copy,
    Icons.forward,
  ];

  List<QueryDocumentSnapshot<Object?>> queryResponse = List<QueryDocumentSnapshot<Object?>>.empty(growable: true);

  @override
  void initState() {
    cancleIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: isMsgSelected
          ? AppBar(
              backgroundColor: UiConstants.myColor,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Text(
                        UserData.userChatMessages
                            .firstWhere((e) => e.userUID == UserData.secondaryUser?.userID)
                            .message
                            .where((e) => e.isSelected == true)
                            .toList()
                            .length
                            .toString(),
                        style: const TextStyle(color: UiConstants.appBarElementsColor),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        chatScreenIcons.length,
                        (index) => ChatScreenIcons(
                              icon: chatScreenIcons.elementAt(index),
                              onpressed: () {
                                appBarFunctions(index);
                              },
                            )),
                  ),
                ],
              ),
              // actions: [
              //   ChatScreenIcons(icon: Icons.more_vert_rounded, onpressed: () {}),
              // ],
              leading: ChatScreenIcons(
                  icon: Icons.close_outlined,
                  onpressed: () {
                    cancleIcon();
                  }),
            )
          : AppBar(
              backgroundColor: UiConstants.myColor,
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
                  Text(
                    UserData.secondaryUser?.name ?? "",
                    style: const TextStyle(color: UiConstants.appBarElementsColor),
                  ),
                ],
              ),
              actions: [
                ChatScreenIcons(
                  icon: Icons.more_vert_rounded,
                  onpressed: () {},
                )
              ],
              leadingWidth: 30,
              leading: ChatScreenIcons(
                  icon: Icons.arrow_back_ios_new,
                  onpressed: () {
                    Navigator.pop(context);
                  })),
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
                        createNewMsg();
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
            // CommonService.closeKeyboard(context);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 65),
            child: StreamBuilder<QuerySnapshot>(
                stream: querySnapshots,
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    buildLoadingFunction(snapShot.data?.docs);
                    if (UserData.userChatMessages.isNotEmpty) {
                      allMsgs = UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message;
                    }
                    return ListView.builder(
                        reverse: true,
                        itemCount: snapShot.data?.docs.length,
                        itemBuilder: (context, index) {
                          msgLength = snapShot.data?.docs.length ?? 0;
                          dynamic mydata = snapShot.data?.docs[index].data();
                          setMessagesCount(UserData.secondaryUser?.userID ?? "", msgLength);

                          // MessageModal message = MessageModal.response(mydata);
                          return MessageTile(
                            message: allMsgs.elementAt(index),
                            status: (index == 0) ? allMsgs.elementAt(index).messageStatus : null,
                            selectedColor: allMsgs.elementAt(index).isSelected ? Colors.cyan.shade100 : null,
                            onLongPress: () {
                              UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.elementAt(index).isSelected =
                                  !UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.elementAt(index).isSelected;

                              if (UserData.userChatMessages
                                  .firstWhere((e) => e.userUID == UserData.secondaryUser?.userID)
                                  .message
                                  .map((e) => e.isSelected)
                                  .toList()
                                  .contains(true)) {
                                isMsgSelected = true;
                              } else {
                                isMsgSelected = false;
                              }

                              setState(() {});
                            },
                            onTap: () {
                              if (isMsgSelected) {
                                UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.elementAt(index).isSelected =
                                    !UserData.userChatMessages
                                        .firstWhere((e) => e.userUID == UserData.secondaryUser?.userID)
                                        .message
                                        .elementAt(index)
                                        .isSelected;

                                if (UserData.userChatMessages
                                    .firstWhere((e) => e.userUID == UserData.secondaryUser?.userID)
                                    .message
                                    .map((e) => e.isSelected)
                                    .toList()
                                    .contains(true)) {
                                  isMsgSelected = true;
                                } else {
                                  isMsgSelected = false;
                                }

                                setState(() {});
                              }
                            },
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
                    return const Center(
                        child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ));
                  }
                }),
          ),
        ),
      ),
    );
  }

  void buildLoadingFunction(List<QueryDocumentSnapshot<Object?>>? qResponse) {
    if (qResponse != null && qResponse.isNotEmpty) {
      queryResponse = qResponse;
      dynamic tempData = qResponse.first.data();
      MessageModal lastMsg = MessageModal.response(tempData);
      if (lastMsg.messageFrom != UserData.primaryUser?.userID) {
        lastMsg.messageStatus = "SEEN";
        lastMsg.chatType = "IND";
        DatabaseMethods().setMsgSeen(lastMsg);
      }
      GetAllUsersMessageModal response = GetAllUsersMessageModal.parseAllUsersDataResponse(qResponse.map((e) => e.data()).toList());

      if (UserData.userChatMessages.isEmpty) {
        UserData.userChatMessages.add(UserChatMessages(userUID: UserData.secondaryUser?.userID ?? "", message: response.allMessageModal));
      } else if (UserData.userChatMessages.map((e) => e.userUID).contains(UserData.secondaryUser?.userID)) {
        if (response.allMessageModal.length != UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.length) {
          UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message = response.allMessageModal;
        } else if (response.allMessageModal.first.messageStatus !=
            UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.first.messageStatus) {
          UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.first = response.allMessageModal.first;
        }
      } else {
        UserData.userChatMessages.add(UserChatMessages(userUID: UserData.secondaryUser?.userID ?? "", message: response.allMessageModal));
      }

      String savingMsg = jsonEncode(UserData.userChatMessages.map((e) => e.getUserMessages()).toList());
      SPS.setvalue("user_chat_messages", savingMsg);

      // List<dynamic> returnmsg = jsonDecode(savingMsg);

    }
  }

  Future<void> setMessagesCount(String id, int value) async {
    SPS.setvalue(id, value);
    if (UserData.usersChatCount.isNotEmpty && UserData.usersChatCount.map((e) => e.userUID).toList().contains(UserData.secondaryUser?.userID)) {
      UserData.usersChatCount.firstWhere((e) => (e.userUID == UserData.secondaryUser?.userID)).messageCount = msgLength;

      for (var item in UserData.userChatList) {
        if (item.userId == UserData.secondaryUser?.userID) {
          UserChatList msdData = item;
          msdData.msgCount = msgLength;
          msdData.seenMsgCount = msgLength;
          DatabaseMethods().setPrimaryUserMsgCount(msdData);
        }
      }
    } else {
      UserData.usersChatCount.add(UserChatCount(UserData.secondaryUser?.userID ?? "", msgLength));
    }
  }

  void createNewMsg() {
    if (message.text.isNotEmpty) {
      MessageModal newMsg = MessageModal(
          messageContent: message.text,
          messageFrom: UserData.primaryUser?.userID ?? "",
          messageTo: UserData.secondaryUser?.userID ?? "",
          messageType: "TEXT",
          messageSentTime: DateTime.now().toString(),
          messageID: "NA",
          messageSecondaryID: "NA",
          messageReplayID: "NA",
          chatType: "INDIVIDUAL",
          messageStatus: "SENT");
      message.clear();
      if (!mounted) return;
      setState(() {});
      DatabaseMethods().createMessage(newMsg, (msgLength + 1));
      setMessagesCount(UserData.secondaryUser?.userID ?? "", msgLength);
      if (UserData.usersChatCount.isEmpty) {
        UserData.usersChatCount.add(UserChatCount(UserData.secondaryUser?.userID ?? "", 1));
      } else if (!UserData.usersChatCount.map((e) => e.userUID).contains(UserData.secondaryUser?.userID)) {
        UserData.usersChatCount.add(UserChatCount(UserData.secondaryUser?.userID ?? "", 1));
      } else {
        UserData.usersChatCount.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).messageCount += 1;
      }
    }
  }

  void appBarFunctions(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        bool isForBoth = true;
        List<String> primIds = List<String>.empty(growable: true);
        List<String> secIds = List<String>.empty(growable: true);
        List<MessageModal> lcmessage = UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message;
        for (var i = 0; i < lcmessage.length; i++) {
          if (lcmessage.elementAt(i).isSelected) {
            if (lcmessage.elementAt(i).messageFrom == UserData.secondaryUser?.userID) {
              isForBoth = false;
            }
            primIds.add(queryResponse.elementAt(i).id);
            secIds.add(lcmessage.elementAt(i).messageSecondaryID);
          }
        }
        UserChatList msdData = UserChatList(
            userId: UserData.secondaryUser?.userID ?? "",
            userName: UserData.secondaryUser?.name ?? "",
            lastMsg: lcmessage.first.messageContent,
            lastMsgTime: lcmessage.first.messageSentTime,
            profileImage: UserData.secondaryUser?.profileImage ?? "",
            msgCount: msgLength,
            seenMsgCount: msgLength);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyAlertBox(
              onCancle: () {
                cancleIcon();
              },
              deleteForMe: () async {
                print(primIds);
                CommonService.closeKeyboard(context);

                await DatabaseMethods().deleteChatMessages(primIds, secIds, false);
                DatabaseMethods().setPrimaryUserMsgCount(msdData);
                cancleIcon();
              },
              deleteForAll: () async {
                print(primIds);
                print(secIds);
                CommonService.closeKeyboard(context);

                await DatabaseMethods().deleteChatMessages(primIds, secIds, true);
                DatabaseMethods().setPrimaryUserMsgCount(msdData);
                DatabaseMethods().setSecondaryUserMsgCount(UserData.secondaryUser?.userID ?? "");
                cancleIcon();
              },
            ).deleteMSgAlert(context, isForBoth);
          },
        );
        break;
      case 2:
        break;
      case 3:
        break;
      default:
        () {};
    }
  }

  void cancleIcon() {
    isMsgSelected = false;
    // CommonService.closeKeyboard(context);

    if (UserData.userChatMessages.isNotEmpty && UserData.userChatMessages.map((e) => e.userUID).contains(UserData.secondaryUser?.userID)) {
      for (var i = 0; i < UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.length; i++) {
        UserData.userChatMessages.firstWhere((e) => e.userUID == UserData.secondaryUser?.userID).message.elementAt(i).isSelected = false;
      }
      if (!mounted) return;
      setState(() {});
    }
  }
}
