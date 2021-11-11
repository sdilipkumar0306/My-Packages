import 'dart:async';

import 'package:flutter/material.dart';
import 'package:our_zone/screens/login_register_pages/login_register_ui.dart';
import 'package:our_zone/screens/main_screens/home_screen/home_ui.dart';
import 'package:our_zone/util/constants/firebase_constants.dart';
import 'package:our_zone/util/constants/ui_constants.dart';
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

}
