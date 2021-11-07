import 'package:flutter/material.dart';
import 'package:our_zone/util/contstants/constants.dart';
import 'package:our_zone/util/data_time_convertipon.dart';
import 'package:our_zone/util/images_display.dart';
import 'package:our_zone/util/modal_classes/common_modails.dart';

class ChatScreen extends StatefulWidget {
  final AllUsersData opponentData;
  const ChatScreen({required this.opponentData,Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // String message =
  //     "dummytext sdfiaslibygs;jgilarsfoashf;asfoEJGLILASIF;JASRGIASGIYWUEFKNWEWE PIWHOIUERGOEIREGIUEWG[UYGAF RUGHOERGOPUERGRJOGEWRPRG QERIHPEWJHOTYPOUERGIEROHU RIHOESIJHOETGOJERGSOITE WEOHERTOITHERTJsrghpotsh etothoritgdsjhgpdsfhiodg gosodghijsdgkjsgibiisdiugbg gksdngihsdglkjds";
  String message = "dummytext ";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            reciverMsg(),
            senderMsg(),
          ],
        ),
      ),
    ));
  }

  // Widget reciverMsg() {
  //   return Container(
  //       // color: Colors.black,
  //       margin: const EdgeInsets.only(right: 60),
  //       child: ListTile(

  //         leading: Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Container(
  //               color: Colors.cyan,
  //               child: const AssetCircularImage(
  //                   height: 40, width: 40, imagePath: UiConstants.logopath),
  //             ),
  //           ],
  //         ),
  //         title: Container(
  //           decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(5), topLeft: Radius.circular(5))),
  //           padding: const EdgeInsets.all(5),
  //           child: Text(
  //             message,
  //             softWrap: true,
  //           ),
  //         ),
  //         subtitle: Container(
  //             decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                     bottomLeft: Radius.circular(5),
  //                     bottomRight: Radius.circular(5))),
  //             padding: const EdgeInsets.all(5),
  //             height: 25,
  //             child: Align(
  //                 alignment: Alignment.bottomRight,
  // child: Padding(
  //   padding: const EdgeInsets.only(right:8.0),
  //   child: Text(
  //       "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}"),
  // ))),
  //         // tileColor: Colors.white,
  //       ));
  // }

  // Widget senderMsg() {
  //   return Container(
  //       // color: Colors.black,
  //       margin: const EdgeInsets.only(left: 70),
  //       child: ListTile(
  //         title: Container(
  //           decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(5), topLeft: Radius.circular(5))),
  //           padding: const EdgeInsets.all(5),
  //           child: Text(
  //             message,
  //             softWrap: true,
  //           ),
  //         ),
  //         subtitle: Container(
  //             decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                     bottomLeft: Radius.circular(5),
  //                     bottomRight: Radius.circular(5))),
  //             padding: const EdgeInsets.all(5),
  //             height: 25,
  //             child: Padding(
  //               padding: const EdgeInsets.only(right: 8.0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Text("${TimeOfDay.now().hour}:${TimeOfDay.now().minute}"),
  //                   const SizedBox(width: 5),
  //                   const Icon(
  //                     Icons.done_all,
  //                     size: 14,
  //                   )
  //                 ],
  //               ),
  //             )),
  //         // tileColor: Colors.white,
  //       ));
  // }

  Widget senderMsg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 60, top: 5, bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                child: Column(
                  children: [
                    Text(
                      message,
                      softWrap: true,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(DateTimeConversion().timeConversion(TimeOfDay.now())),
                        ))
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.white
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.done_all_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget reciverMsg() {
    return Container(
      margin: const EdgeInsets.only(right: 60, top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AssetCircularImage(height: 40, width: 40, imagePath: UiConstants.logopath),
          ),
          const SizedBox(width: 5),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
            child: Column(
              children: [
                Text(
                  message,
                  softWrap: true,
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(DateTimeConversion().timeConversion(TimeOfDay.now())),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget msgBox(String type) {
    return Container(
      margin: (type == "SEND") ? const EdgeInsets.only(left: 60, top: 5, bottom: 5) : const EdgeInsets.only(right: 60, top: 5, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AssetCircularImage(height: 40, width: 40, imagePath: UiConstants.logopath),
          ),
          const SizedBox(width: 5),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
            child: Column(
              children: [
                Text(
                  message,
                  softWrap: true,
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(DateTimeConversion().timeConversion(TimeOfDay.now())),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
