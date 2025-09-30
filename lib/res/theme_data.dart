import 'package:finance/res/sizes.dart';
import 'package:flutter/material.dart';


ThemeData themeData() {
  return ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      // backgroundColor: MyColors.kSage,
      titleTextStyle: TextStyle(
        fontSize: fSize * 1.4,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        size: hScreen * .03,
      ),
    ),
  );
}