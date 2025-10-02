import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/invoiceCard.dart';
import 'package:finance/views/widget/invoice_dialog.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:flutter/material.dart';

class Salesbody extends StatelessWidget {
  const Salesbody({super.key});

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
                  text: "المبيعات والفواتير",
                  fontSize: fSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: MyColors.appTextColorPrimary,
                ),
                CustomText(
                  text: "إدارة جميع الفواتير والمبيعات",
                  fontSize: fSize * 0.8,
                  fontWeight: FontWeight.normal,
                  color: MyColors.appTextColorPrimary,
                ),
              ],
            ),
            CustomMaterialButton(
              title: "فاتورة جديدة",
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
                    return const InvoiceDialog();
                  },
                );
              },
            ),
          ],
        ),

        SizedBox(height: hScreen * 0.03),
        CustomText(
          text: "اجمالي الفواتير",
          fontSize: fSize * 0.8,
          fontWeight: FontWeight.normal,
          color: MyColors.appTextColorPrimary,
        ),
        Padding(
          padding: EdgeInsets.all(hScreen * 0.02),
          child: SummaryBox(
            color: Colors.blue[100],
            icon: Icons.description,
            label: 'فاتورة',
            value: '0',
          ),
        ),
        InvoiceCard(
          invoiceNumber: "INV-001",
          date: "02-10-2025",
          clientName: "شركة المثال",
          currency: "SAR",
          amount: "1500",
          service: "خدمة تصميم",
        ),
      ],
    );
  }

  void showAddInvoiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("إضافة فاتورة جديدة"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "رقم الفاتورة"),
                ),
                TextField(decoration: InputDecoration(labelText: "التاريخ")),
                TextField(
                  decoration: InputDecoration(
                    labelText: "اسم العميل (اختياري)",
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "العملة"),
                  items: <String>['EGP', 'USD', 'EUR'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
                TextField(
                  decoration: InputDecoration(labelText: "المبلغ"),
                  keyboardType: TextInputType.number,
                ),
                TextField(decoration: InputDecoration(labelText: "الوصف")),
                SizedBox(height: 16), 
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("إلغاء"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("حفظ"),
              onPressed: () {
                // كود الحفظ هنا
              },
            ),
          ],
        );
      },
    );
  }
}
