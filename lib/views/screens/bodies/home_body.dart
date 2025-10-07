import 'package:finance/data/services/expenses_service.dart';
import 'package:finance/data/services/invoice_service.dart';
import 'package:finance/data/services/receipts_services.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/routes.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/screens/main_screen.dart';
import 'package:finance/views/widget/actionbutton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ExpenseService expenseService = ExpenseService();
    final ReceiptService receiptService = ReceiptService();
    final InvoiceService invoiceService = InvoiceService();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: hScreen * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: hScreen * 0.01),
          Center(
            child: Text(
              'إجماليات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: hScreen * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<int>(
                future: expenseService.countAllExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('خطأ: ${snapshot.error}');
                  }
                  return SummaryBox(
                    color: Colors.red[100],
                    icon: Icons.attach_money,
                    label: 'مصروف',
                    value: '${snapshot.data ?? 0}',
                  );
                },
              ),
              FutureBuilder<int>(
                future: receiptService.countAllReceipts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('خطأ: ${snapshot.error}');
                  }
                  return SummaryBox(
                    color: Colors.green[100],
                    icon: Icons.check,
                    label: 'سند قبض',
                    value: '${snapshot.data ?? 0}',
                  );
                },
              ),
              FutureBuilder<int>(
                future: invoiceService.countDocumentsInBothCollections(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('خطأ: ${snapshot.error}');
                  }
                  return SummaryBox(
                    color: Colors.blue[100],
                    icon: Icons.description,
                    label: 'فاتورة',
                    value: '${snapshot.data ?? 0}',
                  );
                },
              ),
            ],
          ),
          SizedBox(height: hScreen * 0.08),
          Center(
            child: CustomText(
              text: "إضافة سريعة",
              fontSize: fSize * 1,
              fontWeight: FontWeight.bold,
              color: MyColors.kmainColor,
            ),
          ),
          SizedBox(height: hScreen * 0.02),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                color: Colors.blue,
                icon: Icons.description,
                label: 'إضافة فاتورة جديدة',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 1),
                    ),
                  );
                },
              ),
              ActionButton(
                color: Colors.green,
                icon: Icons.check,
                label: 'إضافة سند قبض',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 2),
                    ),
                  );
                },
              ),
              ActionButton(
                color: Colors.red,
                icon: Icons.attach_money,
                label: 'إضافة مصروف',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(initialIndex: 3),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: hScreen * 0.02),
        ],
      ),
    );
  }
}