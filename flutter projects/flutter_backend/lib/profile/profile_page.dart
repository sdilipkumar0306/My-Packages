import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_backend/home/login_page_modal.dart';
import 'package:google_fonts/google_fonts.dart';

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
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 140,
                      padding: EdgeInsets.only(right: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          btnText,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.upload_file,
                        color: Colors.black,
                        size: 25,
                      ),
                    )
                  ],
                ),
                onPressed: () {
          
                },
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
