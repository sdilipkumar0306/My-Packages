import 'package:flutter/material.dart';
import 'package:our_zone/util/constants/color_constants.dart';
import 'package:our_zone/util/constants/conversion.dart';
import 'package:our_zone/util/modals/firebase_modals.dart';

import '../static_data.dart';

class ChatScreenTile extends StatefulWidget {
  final int index;
  final int count;
  final Function()? onTap;
  final Function()? onlongpress;
  const ChatScreenTile({Key? key, required this.index, required this.count, this.onTap, this.onlongpress}) : super(key: key);

  @override
  State<ChatScreenTile> createState() => _ChatScreenTileState();
}

class _ChatScreenTileState extends State<ChatScreenTile> {
  @override
  Widget build(BuildContext context) {
    return chatListtile();
  }

  Widget chatListtile() {
    return Card(
      elevation: 0,
      child: ListTile(
        selectedTileColor: Colors.grey.shade400,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
        selected: UserData.userChatList.elementAt(widget.index).isSelected,
        title: Text(
          UserData.userChatList.elementAt(widget.index).userName,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          UserData.userChatList.elementAt(widget.index).lastMsg,
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
              DTconversion.getTimeDate(UserData.userChatList.elementAt(widget.index).lastMsgTime)[3],
              style: const TextStyle(color: Colors.black),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              if (UserData.userChatList.elementAt(widget.index).isPinned)
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(Icons.push_pin),
                ),
              if (UserData.userChatList.elementAt(widget.index).isMuted)
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(Icons.volume_off),
                ),
              if (UserData.userChatList.elementAt(widget.index).isAchived)
                const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(Icons.archive),
                ),
              if (widget.count > 0)
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
                  child: Center(
                    child: Text(
                      "${widget.count}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            ]),
            const SizedBox()
          ],
        ),
        onTap: widget.onTap,
        onLongPress: widget.onlongpress,
      ),
    );
  }
}

class ChatScreenIcons extends StatelessWidget {
  final IconData icon;
  final Function()? onpressed;
  const ChatScreenIcons({Key? key, required this.icon, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onpressed,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      splashRadius: 10,
    );
  }
}

class MessageTile extends StatefulWidget {
  final MessageModal message;
  final String? status;
  final Color? selectedColor;
  final void Function()? onLongPress;
  final void Function()? onTap;

  const MessageTile({required this.message, this.status, this.onLongPress, this.selectedColor, this.onTap, Key? key}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    bool sendByMe = (widget.message.messageFrom == UserData.primaryUser?.userID) ? true : false;
    return GestureDetector(
      onLongPress: widget.onLongPress,
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        color: widget.selectedColor ?? Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(top: 6, bottom: 6, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: sendByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
            padding: const EdgeInsets.only(top: 17, bottom: 0, left: 20, right: 15),
            decoration: BoxDecoration(
                borderRadius: sendByMe
                    ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomLeft: Radius.circular(15))
                    : const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                color: sendByMe ? ColorConst.primaryUserMsgColor : ColorConst.secondaryUserMsgColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.message.messageContent,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'OverpassRegular', fontWeight: FontWeight.w300)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DTconversion.getTimeDate(widget.message.messageSentTime)[3],
                        style: TextStyle(fontSize: 10, color: sendByMe ? Colors.black : Colors.white),
                      ),
                      const SizedBox(width: 3),
                      if (widget.status != null && sendByMe)
                        Icon(
                          widget.message.messageStatus == "SEEN" ? Icons.done_all_rounded : Icons.done_rounded,
                          size: 16,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
