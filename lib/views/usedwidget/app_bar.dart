import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:flutter/material.dart';

class AppBarBody extends StatelessWidget {
  const AppBarBody({super.key,required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return AppBar(
       automaticallyImplyLeading: false,
      //  backgroundColor: MyColors.kmainColor,
      backgroundColor:  MyColors.kmainColor,
      title: Padding(
        padding: EdgeInsets.only(right: wScreen * 0.05 ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
               Text(
              text,
              style: TextStyle(fontSize: fSize*1.3,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}