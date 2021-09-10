import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_backend/home/login_page_modal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdk0306/sdk0306.dart';

class ProfilePageUI extends StatefulWidget {
  const ProfilePageUI({Key? key}) : super(key: key);

  @override
  _ProfilePageUIState createState() => _ProfilePageUIState();
}

class _ProfilePageUIState extends State<ProfilePageUI> {
  dynamic imageFileName = "";
  String imageExtension = "";
  String btnText = "Upload Image";
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 30),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    LoginUserDetails.dbID = null;
                    LoginUserDetails.name = null;
                    LoginUserDetails.email = null;
                    LoginUserDetails.password = null;
                  });
                  Navigator.of(context).pop();
                },
                splashRadius: 20,
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          )
        ],
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            // "${LoginUserDetails.name?.toUpperCase()}",
            "Profile",
            style: GoogleFonts.ultra(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        child: Center(
            child: Column(
          children: [
            Container(
              width: 200,
              height: 40,
              child: Buttons(
                ButtonService(
                    buttonData: ButtonData(
                      text: btnText,
                      type: BtnConstants.FILE_PICKER,
                      
                      returnBack: (data) async {
                        if (data == BtnConstants.ON_TAP) {}
                      },
                    ),
                    bGColor: Colors.white,
                    textColor: Colors.black,
                    txtSize: 18,
                    iconColor: Colors.black,
                    borderColor: Colors.black),
              ),
            ),
            // : DecorationImage(
            //     fit: BoxFit.cover,
            //     image: Image.memory(imagevalue).image)),
          ],
        )),
      ),
    );
  }
}
