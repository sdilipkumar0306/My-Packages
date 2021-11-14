import 'package:flutter/material.dart';
import 'package:our_zone/util/constants/conversion.dart';

import '../static_data.dart';

class ChatScreenTile extends StatefulWidget {
  final int index;
  final int count;
  final Function()? onTap;
  final Function()? onlongpress;
  const ChatScreenTile({Key? key, required this.index,required this.count, this.onTap, this.onlongpress}) : super(key: key);

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
