import 'package:flutter/material.dart';

import 'splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Our Zone',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const  MyCustomSplashScreen(
        
      ),
    );
  }
}
