import 'package:flutter/material.dart';
import 'package:fuse/util/common_utils.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              if (isDark) {
                setAsLight(context);
              } else {
                setAsDark(context);
              }
              isDark = !isDark;
              notMounted(mounted, setState);
            },
            child: Text(isDark.toString())),
      ),
    );
  }
}
