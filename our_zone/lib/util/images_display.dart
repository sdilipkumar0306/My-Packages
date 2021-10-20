import 'package:flutter/material.dart';

class AssetCircularImage extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;
  const AssetCircularImage(
      {required this.height,
      required this.width,
      required this.imagePath,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: width,
        width: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ));
  }
}
