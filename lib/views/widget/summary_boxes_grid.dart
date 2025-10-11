import 'package:flutter/material.dart';
import 'package:finance/cubits/reports_cubit/report_state.dart'; // ReportsLoaded
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/summarybox.dart'; // SummaryBox

class SummaryBoxesGrid extends StatelessWidget {
  final ReportsLoaded loadedState;

  const SummaryBoxesGrid({super.key, required this.loadedState});

  @override
  Widget build(BuildContext context) {
    final netProfit = loadedState.totalInvoices - loadedState.totalExpenses;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryBox(
                color: Colors.green[100],
                icon: Icons.shopping_cart,
                label: 'إجمالي المبيعات',
                value: loadedState.totalInvoices.toStringAsFixed(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryBox(
                color: Colors.red[100],
                icon: Icons.money_off,
                label: 'إجمالي المصروفات',
                value: loadedState.totalExpenses.toStringAsFixed(2),
              ),
            ),
          ],
        ),
        SizedBox(height: hScreen * 0.015),
        Row(
          children: [
            Expanded(
              child: SummaryBox(
                color: Colors.blue[100],
                icon: Icons.receipt,
                label: 'إجمالي السندات',
                value: loadedState.totalReceipts.toStringAsFixed(0),
              ),
            ),
            SizedBox(width: hScreen * 0.015),
            Expanded(
              child: SummaryBox(
                color: Colors.purple[100],
                icon: Icons.show_chart,
                label: 'صافي الربح',
                value: netProfit.toStringAsFixed(2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}