
import 'package:finance/res/sizes.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  void Function()? onTap;

   ActionButton({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin:EdgeInsets.symmetric(vertical: hScreen*0.01),
        padding:  EdgeInsets.symmetric(horizontal: wScreen*0.01, vertical: hScreen*0.015),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1), 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, color: color),
             SizedBox(width: wScreen*0.02),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: fSize*1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}