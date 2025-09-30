import 'package:finance/views/screens/bodies/expense_Body.dart';
import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  const Expenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expensebody(),
    );
  }
}