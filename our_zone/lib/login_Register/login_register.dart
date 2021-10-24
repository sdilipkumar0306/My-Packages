import 'package:flutter/material.dart';
import 'dart:ui';

import 'login_page.dart';
import 'register_page.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool isLoginpage = true;
  @override
  void initState() {
    super.initState();
  }

  void pageChanging() {
    setState(() {
      isLoginpage = !isLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoginpage ? LoginPage(changePage: pageChanging) : RegisterPage(changePage: pageChanging),
    );
  }
}


