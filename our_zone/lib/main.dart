import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:our_zone/util/constants/ui_constants.dart';

import 'screens/splash_screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: UiConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const SplashScreenUI(),
    );
  }
}
