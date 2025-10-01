import 'package:finance/res/sizes.dart';
import 'package:finance/views/screens/bodies/home_body.dart';
import 'package:finance/views/usedwidget/app_bar.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar:PreferredSize(preferredSize:Size.fromHeight(hScreen* 0.1), child: const AppBarBody(text: "الرئيسية")),
     body:Padding(
      padding: const EdgeInsets.all(16.0),
      child: HomeBody()
    )
   );
  }
}