// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home/home_page_ui.dart';
import 'util/theme/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return ThemeManager(
        defaultBrightnessPreference: BrightnessPreference.system,
        data: (Brightness brightness) => ThemeData(
              primarySwatch: Colors.blue,
              brightness: brightness,
            ),
        loadBrightnessOnStart: true,
        themedWidgetBuilder: (BuildContext context, ThemeData theme) {
          return MaterialApp(
            title: 'Fuse',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: getFirebaseResponseWidget(),
          );
        });
  }

  Widget getFirebaseResponseWidget() {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return somethingWentWrong();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const MainHomePage();
        }
        return loading();
      },
    );
  }

  Widget somethingWentWrong() {
    return const Scaffold(
      body: Center(
        child: Text("Something Wrong"),
      ),
    );
  }

  Widget loading() {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
