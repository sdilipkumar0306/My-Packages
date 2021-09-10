import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_backend/home/login_page.dart';
import 'package:flutter_backend/home/login_page_modal.dart';
import 'package:flutter_backend/service/http_service_modal.dart';
import 'package:flutter_backend/service/https_service.dart';
import 'package:flutter_backend/util/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPageUI()));
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  height: imageSize,
                  width: imageSize,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyan)),
                  child: ClipOval(
                    child: (kIsWeb)
                        ? (userSubmittedImagesForUint8List != null)
                            ? Container(
                                child: Image.memory(
                                  userSubmittedImagesForUint8List!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Center(child: Text("No Image Found"))
                        : (userSubmittedImages != null)
                            ? Image.file(
                                File(userSubmittedImages!),
                                height: 300,
                                width: 300,
                              )
                            : Text("No Image Found"),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: imageSize * 0.07,
                  child: Container(
                      child: SDKImagePicker(
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
                            HTTPServiceModal imgResponse = await HTTPservice.upload(userSubmittedImagesForUint8List, userSubmittedExtension, fileName);

                            if (imgResponse.code == 200) {
                              HTTPServiceModal dbImgResponse = await createUser(imgResponse.msg);
                            }
                          })),
                )
              ],
            ),
          ),
          // Center(
          //   child: Container(
          //     child: SDKImagePicker(
          //         circleBtn: true,
          //         returnPath: (String imagePath, uint8List) {
          //           setState(() {
          //             if (kIsWeb) {
          //               userSubmittedImagesForUint8List = uint8List;
          //             } else {
          //               userSubmittedImages = imagePath;
          //             }
          //           });
          //         }),
          //   ),
          // ),
          // Container(
          //     child: (kIsWeb)
          //         ? (userSubmittedImagesForUint8List != null)
          //             ? Image.memory(
          //                 userSubmittedImagesForUint8List!,
          //                 height: 200,
          //                 width: 200,
          //               )
          //             : Text("No Image Found")
          //         : (userSubmittedImages != null)
          //             ? Image.file(
          //                 File(userSubmittedImages!),
          //                 height: 200,
          //                 width: 200,
          //               )
          //             : Text("No Image Found"))
        ],
      )),
    );
  }

  Future<HTTPServiceModal> createUser(url) async {
    var json = {"user_id": "${LoginUserDetails.dbID}", "image_url": "$url"};
    print(json);
    HTTPServiceModal response = await HTTPservice.postCallWithAuth("user/UPLOAD_USER_PROFILE_IMAGE", json);

    if (response.code == 200) {
    } else {}

    return response;
  }
}
