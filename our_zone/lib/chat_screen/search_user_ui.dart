import 'package:flutter/material.dart';
import 'package:our_zone/util/common_service.dart';
import 'package:our_zone/util/data_time_convertipon.dart';

import 'user_chats.dart';

class SearchUserUI extends StatefulWidget {
  const SearchUserUI({Key? key}) : super(key: key);

  @override
  _SearchUserUIState createState() => _SearchUserUIState();
}

class _SearchUserUIState extends State<SearchUserUI> {
  Size size = const Size(0, 0);
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Friends"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () async {},
        //     icon: const Icon(Icons.more_vert_rounded),
        //     splashRadius: 10,
        //   ),
        // ],
        leadingWidth: 30,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          splashRadius: 10,
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height - 50,
        child: GestureDetector(
          onTap: () {
            print("tapppp");
            CommonService.closeKeyboard(context);
          },
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: size.width - 50,
                        height: 50,
                        child: TextFormField(
                          controller: message,
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                          decoration: const InputDecoration(
                              hintText: "Search...",
                              hintStyle: TextStyle(color: Colors.black),
                              // prefixIcon: IconButton(
                              //     onPressed: () {},
                              //     icon: const Icon(
                              //       Icons.emoji_emotions_outlined,
                              //       size: 30,
                              //       color: Colors.white,
                              //     )),

                              filled: true,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.white)),
                              focusColor: Colors.white,
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10.0)))),
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
                                  CommonService.closeKeyboard(context);
                                },
                                icon: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                ))),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(10, (index) => chatListtile(title: "title - $index", lastText: "lastText - $index")),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatListtile({
    required String title,
    required String lastText,
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
        trailing: IconButton(
          onPressed: () {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatMainUI()));
          },
          icon: const Icon(Icons.message_rounded),
          splashRadius: 10,
        ),
        onTap: (){
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChatMainUI()));
        },
      ),
    );
  }
}
