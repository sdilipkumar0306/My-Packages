import 'package:flutter/material.dart';

class DTconversion {
  /// Takes [ TimeOfDay ] as Input and Returns [ HH:MM PM/AM ]
  static String timeConversion(TimeOfDay time) {
    String hour = ((time.hour > 12) ? time.hour - 12 : time.hour).toString();
    String formate = ((time.hour >= 12) ? "PM" : "AM");
    if (hour.length == 1) hour = "0$hour";
    String min = time.minute.toString();
    if (min.length == 1) min = "0$min";
    hour = hour == "00" ? "12" : hour;

    return "$hour:$min $formate";
  }

  static String getMonth(int month) {
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months.elementAt(month - 1);
  }

  /// Output
  ///
  ///  0 - [ dMonthY ] --->  12 January 2021
  ///
  ///  1-  [ dmy ] --->  12-11-2021
  ///
  ///  2 - [ ymd ] --->  2021-11-12
  ///
  ///  3 - [ time12 ] --->  08:21 PM
  ///
  ///  4 - [ time24 ] --->  20:21
  ///
  ///  5 - [ dmyT12 ] --->  12-11-2021 08:21 PM
  ///
  ///  6 - [ ymdT12 ] --->  2021-11-12 08:21 PM
  ///
  static List<String> getTimeDate(String dataTime) {
    DateTime newDT = DateTime.parse(dataTime);
    String dMonthY = "${newDT.day} ${getMonth(newDT.month)} ${newDT.year}";
    String dmy = "${newDT.day}-${newDT.month}-${newDT.year}";
    String ymd = "${newDT.year}-${newDT.month}-${newDT.day}";
    String time12 = timeConversion(TimeOfDay(hour: newDT.hour, minute: newDT.minute));
    String time24 = "${newDT.hour}:${newDT.minute}";
    String dmyT12 = "$dmy $time12";
    String ymdT12 = "$ymd $time12";

    return [dMonthY, dmy, ymd, time12, time24, dmyT12, ymdT12];
  }
}
