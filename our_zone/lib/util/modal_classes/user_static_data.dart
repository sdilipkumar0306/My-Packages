import 'package:our_zone/util/modal_classes/chat_list_modal.dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_modal.dart';

class UserData {
  static UserDetailsmodal? userdetails;
  static  List<MainpageChatModal> messagesList = List<MainpageChatModal>.empty(growable: true);

  static Future getUserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userUID = prefs.getString("user_login_id") ?? "";

  }
}
