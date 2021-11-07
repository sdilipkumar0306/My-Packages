import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/util/common_service.dart';
import 'package:our_zone/util/modal_classes/common_modails.dart';
import 'package:our_zone/util/modal_classes/user_static_data.dart';
import 'package:our_zone/util/services/db_service.dart';

import 'user_chats.dart';

class SearchUserUI extends StatefulWidget {
  const SearchUserUI({Key? key}) : super(key: key);

  @override
  _SearchUserUIState createState() => _SearchUserUIState();
}

class _SearchUserUIState extends State<SearchUserUI> {
  Size size = const Size(0, 0);
  TextEditingController searchController = TextEditingController();

  List<AllUsersData> allusersdata = List<AllUsersData>.empty(growable: true);
  List<AllUsersData> filteruserData = List<AllUsersData>.empty(growable: true);

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  Future<void> getAllUserDetails() async {
    List<AllUsersData> response = await DatabaseMethods().getAllUserDetails();
    allusersdata = response;
    allusersdata.removeWhere((e) => e.id == UserData.userdetails?.userID);
    filteruserData = allusersdata;
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Friends"),
        centerTitle: true,
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
                          controller: searchController,
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                          decoration: const InputDecoration(
                              hintText: "Search...",
                              hintStyle: TextStyle(color: Colors.black),
                              filled: true,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.white)),
                              focusColor: Colors.white,
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                          onChanged: (data) {
                            if (searchController.text.length > 1) {
                              filteruserData =
                                  allusersdata.where((e) => e.userName.contains(searchController.text) || e.email.contains(searchController.text)).toList();
                            } else {
                              filteruserData = allusersdata;
                            }

                            if (!mounted) return;
                            setState(() {});
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(color: Colors.cyan.shade700, shape: BoxShape.circle),
                        child: Center(
                            child: IconButton(
                                onPressed: () async {
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
                      children: List.generate(filteruserData.length, (index) => chatListtile(index: index)),
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

  Widget chatListtile({required int index}) {
    return Card(
      child: ListTile(
        title: Text(filteruserData.elementAt(index).userName),
        subtitle: Text(filteruserData.elementAt(index).email),
        minLeadingWidth: 50,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
          child: const Center(child: Icon(Icons.person)),
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatMainUI(opponentData: filteruserData.elementAt(index))));
          },
          icon: const Icon(Icons.message_rounded),
          splashRadius: 10,
        ),
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatMainUI(opponentData: filteruserData.elementAt(index))));
        },
      ),
    );
  }
}
