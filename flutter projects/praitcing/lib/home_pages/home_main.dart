import 'package:flutter/material.dart';
import 'package:praitcing/util/pages/title_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double rotaionAngle = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const TitlePageUI("Home Page"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
            child: AnimatedContainer(
          width: rotaionAngle,
          height: rotaionAngle,
          duration: const Duration(seconds: 2),
          child: Container(
            decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    rotaionAngle = 180;
                  });
                },
                icon: const Icon(Icons.refresh)),
          ),
        )),
      ),
    );
  }
}
