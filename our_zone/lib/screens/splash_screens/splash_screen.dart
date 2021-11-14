import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:our_zone/screens/login_register_pages/login_register_ui.dart';
import 'package:our_zone/screens/main_screens/home_screen/home_ui.dart';
import 'package:our_zone/util/constants/conversion.dart';
import 'package:our_zone/util/constants/firebase_constants.dart';
import 'package:our_zone/util/constants/ui_constants.dart';
import 'package:our_zone/util/modals/common_modals.dart';
import 'package:our_zone/util/modals/firebase_modals.dart';
import 'package:our_zone/util/service/data_base_service.dart';
import 'package:our_zone/util/service/sharedpreference_service.dart';
import 'package:our_zone/util/static_data.dart';
import 'package:our_zone/util/widgets_ui/images_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({Key? key}) : super(key: key);

  @override
  _SplashScreenUIState createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  final double _imageSize = 200;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    String? uid = await SPS.getValue(UserConst.userID, String);
    if (uid != null) {
      FBUser? user = await DatabaseMethods().getUserDetails(uid);
      if (user != null) {
        String? userChatList = await SPS.getValue("user_chat_list", String) ?? "";
        if (userChatList != null) {
          List<dynamic> data = jsonDecode(userChatList);
          GetUserChatListResponse response = GetUserChatListResponse.parseUserChatListResponse(data);
          UserData.userChatList = response.userChatList;
          getmsgUiprop();
          getmsgCounts();
        }
        UserData.primaryUser = user;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreenUI()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInRegisterUI()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInRegisterUI()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyan.shade400,
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200))),
                  child: ImagesOZ(
                    image: UiConstants.logopath,
                    borderRadius: const BorderRadius.all(Radius.circular(500)),
                    width: _imageSize,
                    height: _imageSize,
                  )),
              SizedBox(
                width: _imageSize + 5,
                height: _imageSize + 5,
                child: const CircularProgressIndicator(
                  color: UiConstants.myColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getmsgUiprop() async {
    List<String> ids = UserData.userChatList.map((e) => e.userId).toList();
    for (var i in ids) {
      List<bool> response = await SPS.getUserChatprop(i);
      UserData.userChatList.firstWhere((e) => e.userId == i).isPinned = response[0];
      UserData.userChatList.firstWhere((e) => e.userId == i).isMuted = response[1];
      UserData.userChatList.firstWhere((e) => e.userId == i).isAchived = response[2];
    }
  }

  Future<void> getmsgCounts() async {
    List<String> ids = UserData.userChatList.map((e) => e.userId).toList();
    for (var i in ids) {
      int? res = await SPS.getValue(i, int);
      UserData.usersChatCount.add(UserChatCount(i, (res == null) ? 1 : res));
    }
  }
}
