import 'package:flutter/material.dart';

class TitlePageUI extends StatefulWidget {
  final String title;

  final Color textColor;
  const TitlePageUI(this.title, {this.textColor: Colors.white, Key? key}) : super(key: key);

  @override
  _TitlePageUIState createState() => _TitlePageUIState();
}

class _TitlePageUIState extends State<TitlePageUI> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.title,
      style: TextStyle(color: widget.textColor, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
