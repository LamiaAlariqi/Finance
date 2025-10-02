import 'package:finance/res/sizes.dart';
import 'package:finance/views/screens/bodies/receipts_Body.dart';
import 'package:finance/views/usedwidget/app_bar.dart';
import 'package:flutter/material.dart';

class Receipts extends StatelessWidget {
  const Receipts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(preferredSize:Size.fromHeight(hScreen* 0.07), child: const AppBarBody(text: "سندات القبض")),
     body:Padding(
      padding:EdgeInsets.all(hScreen*0.01),
      child: ReceiptsBody(),
    ));
  }
}