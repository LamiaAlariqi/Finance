import 'package:finance/res/color_app.dart';
import 'package:flutter/material.dart';
import 'package:finance/res/sizes.dart';  

class AppThemeData {


  static ThemeData lightTheme() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor:  Colors.white,
          titleTextStyle: TextStyle(
            fontSize: fSize * 1.4,
            fontWeight: FontWeight.bold,
            color: MyColors.appTextColorPrimary,
          ),
          iconTheme: IconThemeData(
            size: hScreen * .03,
            color: MyColors.appTextColorPrimary,
          ),
        ),

        iconTheme: IconThemeData(
          size: 28,
          color: MyColors.appTextColorPrimary,
        ),

        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:  BorderSide(width: 1.0, color: MyColors.kmainColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide:  BorderSide(width: 1.0, color: MyColors.kmainColor),
          ),
        ),

       
      );
}
