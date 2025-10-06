import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/invoiceCard.dart';
import 'package:finance/views/dialogs/receipt_dialog.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:flutter/material.dart';

class ReceiptsBody extends StatelessWidget {
  const ReceiptsBody({super.key});

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
                  text: "سندات القبض",
                  fontSize: fSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: MyColors.appTextColorPrimary,
                ),
                CustomText(
                  text: "إدارة جميع سندات القبض",
                  fontSize: fSize * 0.8,
                  fontWeight: FontWeight.normal,
                  color: MyColors.appTextColorPrimary,
                ),
              ],
            ),
            CustomMaterialButton(
              title: "سند قبض جديد",
              vertical: hScreen * 0.01,
              buttonColor: Colors.blue[100]!,
              textColor: MyColors.appTextColorPrimary,
              borderWidth: 0.5,
              borderColor: Colors.blue[100]!,
              height: hScreen * 0.06,
              width: wScreen * 0.25,
              textsize: fSize * 0.8,
              onPressed: () {
               showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const ReceiptDialog();
                  },);
              },
            ),
          ],
        ),

        SizedBox(height: hScreen * 0.03),
        CustomText(
          text: "إجمالي السندات",
          fontSize: fSize * 0.8,
          fontWeight: FontWeight.normal,
          color: MyColors.appTextColorPrimary,
        ),
        Padding(
          padding: EdgeInsets.all(hScreen * 0.02),
          child: SummaryBox(
            color: Colors.blue[100],
            icon: Icons.receipt_long,
            label: 'سند',
            value: '0',
          ),
        ),
        InvoiceCard(
          invoiceNumber: "RCPT-001",
          date: "03-10-2025",
          clientName: "مؤسسة التجربة",
          currency: "SAR",
          amount: "2500",
          productnumber: "دفعة أولى",
        ),
      ],
    );
  }

}
