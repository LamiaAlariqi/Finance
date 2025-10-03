import 'package:finance/res/sizes.dart';
import 'package:finance/views/screens/bodies/expense_Body.dart';
import 'package:finance/views/usedwidget/app_bar.dart';
import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  const Expenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:PreferredSize(preferredSize:Size.fromHeight(hScreen* 0.07), child: const AppBarBody(text: "المصروفات")),
     body:Padding(
      padding: const EdgeInsets.all(16.0),
      child:  ExpensesBody(),
    ));
  }
}