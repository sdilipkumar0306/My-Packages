import 'package:flutter/material.dart';

class UiConstants {
  static const String logopath = "assets/images/Our_Zone_logo.png";
  static const String loadingGif1 = "assets/images/loader.gif";
  static const String loadingGif2 = "assets/images/loading.gif";
  static const String appName = "Our_Zone";
  static const Color myColor = Color(0xff072b30);

  static RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static Map<int, Color> color = {
    50: const Color(0xff072b30).withAlpha(1),
    100: const Color(0xff072b30).withAlpha(2),
    200: const Color(0xff072b30).withAlpha(3),
    300: const Color(0xff072b30).withAlpha(4),
    400: const Color(0xff072b30).withAlpha(5),
    500: const Color(0xff072b30).withAlpha(6),
    600: const Color(0xff072b30).withAlpha(7),
    700: const Color(0xff072b30).withAlpha(8),
    800: const Color(0xff072b30).withAlpha(9),
    900: const Color(0xff072b30).withAlpha(10),
  };
}
