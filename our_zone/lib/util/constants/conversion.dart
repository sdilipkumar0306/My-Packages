import 'package:flutter/material.dart';

class DTconversion {
  /// Takes [ TimeOfDay ] as Input and Returns [ HH:MM PM/AM ]
  static String timeConversion(TimeOfDay time) {
    String hour = ((time.hour > 12) ? time.hour - 12 : time.hour).toString();
    String formate = ((time.hour >= 12) ? "pm" : "am");
    if (hour.length == 1) hour = "0$hour";
    String min = time.minute.toString();
    if (min.length == 1) min = "0$min";
    return "$hour:$min $formate";
  }
}
