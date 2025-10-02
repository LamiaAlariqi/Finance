import 'package:finance/res/sizes.dart';
import 'package:flutter/material.dart';

class SummaryBox extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String label;
  final String value;
SummaryBox({this.color, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wScreen*0.28,
      padding: EdgeInsets.all(hScreen*0.02),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Icon(icon),
          SizedBox(height: hScreen*0.02),
          Text('$value $label', textDirection: TextDirection.rtl),
        ],
      ),
    );
  }
}


