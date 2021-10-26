import 'package:flutter/material.dart';
import 'package:our_zone/chat_screen/search_user_ui.dart';
import 'package:our_zone/chat_screen/user_chats.dart';
import 'package:our_zone/login_Register/login_register.dart';
import 'package:our_zone/util/constants.dart';
import 'package:our_zone/util/data_time_convertipon.dart';
import 'package:our_zone/util/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  Size size = const Size(0, 0);

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

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginRegister()));
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
        // padding: const EdgeInsets.only(bottom: 50),
        width: size.width,
        height: size.height - 50,
        child: SingleChildScrollView(
          child: Column(
            // children: List.generate(10, (index) {
            // return chatListtile(
            //       title: "title - $index",
            //       lastText: "lastText - $index",
            //       count: index,
            //       response: (resType) {
            //         if (resType == "ON_TAP") {
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatMainUI()));
            //         }
            //       });
            // }),
            children: [
              SizedBox(
                height: size.height,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 200),
                    scrollDirection: Axis.vertical,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return chatListtile(
                          title: "title - $index",
                          lastText: "lastText - $index",
                          count: index,
                          response: (resType) {
                            if (resType == "ON_TAP") {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatMainUI()));
                            }
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatListtile({
    required String title,
    required String lastText,
    required int count,
    required Function(String) response,
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
        onTap: () {
          response("ON_TAP");
        },
        onLongPress: () {
          response("ON_LONG_PRESS");
        },
      ),
    );
  }
}
