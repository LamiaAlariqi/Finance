import 'package:finance/res/sizes.dart';
import 'package:finance/views/screens/bodies/sales_Body.dart';
import 'package:finance/views/usedwidget/app_bar.dart';
import 'package:flutter/material.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:PreferredSize(preferredSize:Size.fromHeight(hScreen* 0.1), child: const AppBarBody(text: "المبيعات")),
     body:Padding(
      padding: const EdgeInsets.all(16.0),
      child: Salesbody(),
     ) );
  }
}