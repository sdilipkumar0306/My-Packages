import 'package:flutter/material.dart';

import 'login_page.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({Key? key}) : super(key: key);

  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPageUI(),
    );
  }
}
