import 'package:finance/views/screens/bodies/receipts_Body.dart';
import 'package:flutter/material.dart';

class Receipts extends StatelessWidget {
  const Receipts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReceiptsBody(),
    );
  }
}