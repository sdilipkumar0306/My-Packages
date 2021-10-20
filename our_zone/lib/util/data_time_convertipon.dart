import 'package:flutter/material.dart';

class DateTimeConversion {
  String timeConversion(TimeOfDay time) {
    String hour = ((time.hour > 12) ? time.hour - 12 : time.hour).toString();
    String formate = ((time.hour >= 12) ? "pm" : "am");

    return "$hour:${time.minute} $formate";
  }
}
