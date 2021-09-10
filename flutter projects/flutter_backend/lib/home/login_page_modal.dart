import 'package:flutter/material.dart';

class LoginpageModal {
  bool isloginPasswordVisable = false;
  bool isRegisterPasswordVisable = false;
  bool isLoginPage = true;
  String loginMSG = "";
  Color loginMSGColor = Colors.red;
  LoginpageModal();
}

class LoginUserDetails {
  static String? name;
  static String? email;
  static String? password;
  static int? dbID;
  LoginUserDetails();
}
