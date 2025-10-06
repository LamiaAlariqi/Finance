import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/dialogs/expenses_dialog.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:flutter/material.dart';
import 'package:finance/views/widget/custom/customTextFormField.dart';

class ExpensesBody extends StatelessWidget {
  const ExpensesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: hScreen * 0.03),
                CustomText(
                  text: "المصروفات",
                  fontSize: fSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: MyColors.appTextColorPrimary,
                ),
                CustomText(
                  text: "إدارة جميع المصروفات",
                  fontSize: fSize * 0.8,
                  fontWeight: FontWeight.normal,
                  color: MyColors.appTextColorPrimary,
                ),
              ],
            ),
            CustomMaterialButton(
              title: "إضافة مصروف جديد",
              vertical: hScreen * 0.01,
              buttonColor: Colors.blue[100]!,
              textColor: MyColors.appTextColorPrimary,
              borderWidth: 0.5,
              borderColor: Colors.green[100]!,
              height: hScreen * 0.06,
              width: wScreen * 0.35,
              textsize: fSize * 0.8,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ExpenseDialog();
                  },
                );
              },
            ),
          ],
        ),

        SizedBox(height: hScreen * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(hScreen * 0.01),
                child: SummaryBox(
                  color: Colors.blue[100],
                  icon: Icons.summarize,
                  label: 'إجمالي المصروفات',
                  value: '0',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(hScreen * 0.01),
                child: SummaryBox(
                  color: Colors.green[100],
                  icon: Icons.trending_up,
                  label: 'أعلى مصروف',
                  value: '0',
                ),
              ),
            ),
          ],
        ),

        // ===== لستة تجريبية =====
        ListTile(
          leading: Icon(Icons.money_off, color: Colors.red[400]),
          title: const Text("مصروف: إيجار المكتب"),
          subtitle: const Text("01-10-2025 | 2000 SAR"),
          trailing: const Text("2000"),
        ),
        ListTile(
          leading: Icon(Icons.money_off, color: Colors.red[400]),
          title: const Text("مصروف: كهرباء"),
          subtitle: const Text("25-09-2025 | 500 SAR"),
          trailing: const Text("500"),
        ),
      ],
    );
  }
}

