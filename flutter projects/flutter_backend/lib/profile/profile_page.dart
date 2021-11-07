import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_backend/home/login_page.dart';
import 'package:flutter_backend/home/login_page_modal.dart';
import 'package:flutter_backend/service/http_service_modal.dart';
import 'package:flutter_backend/service/https_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdk0306/sdk0306.dart';

class ProfilePageUI extends StatefulWidget {
  const ProfilePageUI({Key? key}) : super(key: key);

  @override
  _ProfilePageUIState createState() => _ProfilePageUIState();
}

class _ProfilePageUIState extends State<ProfilePageUI> {
  String? userSubmittedImages;
  String? userSubmittedExtension;
  Uint8List? userSubmittedImagesForUint8List;
  double imageSize = 200;

  List<int> myList = List<int>.empty(growable: true);
  String? imageURL;
  String localurl = "https://st2.depositphotos.com/1104517/11965/v/600/depositphotos_119659092-stock-illustration-male-avatar-profile-picture-vector.jpg";
  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Profile",
            style: GoogleFonts.ultra(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(child: imageDisplay()),
          Container(child: profileDetails()),
        ],
      )),
    );
  }

  Widget imageDisplay() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Stack(
        children: [
          Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyan)),
            child: ClipOval(
              child: Image.network(
                imageURL ?? localurl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: imageSize * 0.07,
            child: Container(
                child: ImagePickersdk(
                    circleBtn: true,
                    returnPath: (String imagePath, uint8List, fileName) async {
                      setState(() {
                        if (kIsWeb) {
                          userSubmittedImagesForUint8List = uint8List;
                          userSubmittedExtension = imagePath;
                        } else {
                          userSubmittedImages = imagePath;
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Updating Profile....."),
                        duration: Duration(milliseconds: 200),
                        dismissDirection: DismissDirection.endToStart,
                      ));
                      HTTPServiceModal? dbImgResponse;
                      HTTPServiceModal imgResponse = await HTTPservice.upload(userSubmittedImagesForUint8List, userSubmittedExtension, fileName);
                      if (imgResponse.code == 200) {
                        if (imageURL == null) {
                          dbImgResponse = await newUserProfile(imgResponse.msg);
                        } else {
                          dbImgResponse = await updateUserProfile(imgResponse.msg);
                        }
                      }
                      if (dbImgResponse != null && dbImgResponse.code == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Profile Updated"),
                          duration: Duration(milliseconds: 200),
                          dismissDirection: DismissDirection.up,
                        ));
                        setState(() {
                          imageURL = imgResponse.msg;
                        });
                      }
                    })),
          )
        ],
      ),
    );
  }

  Widget profileDetails() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Name :", style: GoogleFonts.abrilFatface(color: Colors.black, fontSize: 30)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${LoginUserDetails.name}",
                          style: GoogleFonts.playball(fontSize: 25, wordSpacing: 9, color: Colors.black, fontWeight: FontWeight.bold)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Email :", style: GoogleFonts.abrilFatface(color: Colors.black, fontSize: 30)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${LoginUserDetails.email}",
                          style: GoogleFonts.playball(fontSize: 25, wordSpacing: 9, color: Colors.black, fontWeight: FontWeight.bold)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<HTTPServiceModal> newUserProfile(url) async {
    var json = {"user_id": "${LoginUserDetails.dbID}", "image_url": "$url"};
    HTTPServiceModal response = await HTTPservice.postCallWithAuth("user/UPLOAD_USER_PROFILE_IMAGE", json);

    if (response.code == 200) {
    } else {}

    return response;
  }

  Future<HTTPServiceModal> updateUserProfile(url) async {
    var json = {"user_id": "${LoginUserDetails.dbID}", "image_url": "$url"};
    HTTPServiceModal response = await HTTPservice.postCallWithAuth("user/UPDATE_USER_PROFILE_IMAGE", json);

    if (response.code == 200) {
    } else {}

    return response;
  }

  Future<HTTPServiceModal> getUserProfile() async {
    var json = {"user_id": "${LoginUserDetails.dbID}"};
    HTTPServiceModal response = await HTTPservice.postCallWithAuth("user/GET_USER_PROFILE_IMAGE", json);

    if (response.code == 200) {
      setState(() {
        imageURL = response.msg[0]["IMAGE_URL"];
      });
    } else {
      imageURL = null;
    }

    return response;
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.cyan, fontSize: 25),
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              LoginUserDetails.dbID = null;
              LoginUserDetails.name = null;
              LoginUserDetails.email = null;
              LoginUserDetails.password = null;
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPageUI()));
            },
          ),
        ],
      ),
    );
  }
}
