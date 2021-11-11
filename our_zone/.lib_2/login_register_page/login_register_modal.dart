import 'package:flutter/material.dart';

class LoginGegister {
  Color myColor = const Color(0xff072b30);
  bool isPageChanged = false;
  bool isenable = false;
  bool visableIcons = true;
  Duration dur = const Duration(milliseconds: 400);
  Size size = const Size(500, 500);
  double containerSize = 50;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userNameError;
  String? emmailError;
  String? passwoedError;

  bool isbuttonClicked = false;
  bool enableButton = true;

  double primaryContainerposition = 0;
  double mainContainerBorderRadius = 0;
  double imageContainerSize = 0;
  double imageContainerLeftPosition = 0;
  double imagecontainerBottomPosition = 0;
  double textContainerLeftPosition = 0;
  double textcontainerBottomPosition = 0;
  double contentContainerHeight = 0;
}
