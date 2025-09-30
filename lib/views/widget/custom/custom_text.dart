import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color; 

  const CustomText({
    Key? key,
    required this.title,
     required this.fontSize,
    required this.fontWeight,
    this.color,  //optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color?? Colors.black, 
      ),
      textAlign: TextAlign.center,
    );
  }
}