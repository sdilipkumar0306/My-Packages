import 'package:flutter/material.dart';

import 'home/home_page_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDK0306',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageUI(),
    );
  }
}
