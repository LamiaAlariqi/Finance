import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double? verticalPadding;
  final double width;
  final double height;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required  this.backgroundColor,
     required this.textColor,
     required this.height,
     required this.width,
    this.verticalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 15),
        ),
      ),
    );
  }
}