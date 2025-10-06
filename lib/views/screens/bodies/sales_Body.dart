import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/invoiceCard.dart';
import 'package:finance/views/dialogs/invoice_dialog.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:flutter/material.dart';

class SalesBody extends StatefulWidget {
  const SalesBody({super.key});

  @override
  State<SalesBody> createState() => _SalesBodyState();
}

class _SalesBodyState extends State<SalesBody> {
  String? _selectedMonth; // متغير لتخزين الشهر المحدد
  List<String> months = [
    "يناير",
    "فبراير",
    "مارس",
    "أبريل",
    "مايو",
    "يونيو",
    "يوليو",
    "أغسطس",
    "سبتمبر",
    "أكتوبر",
    "نوفمبر",
    "ديسمبر"
  ];

  // خريطة لتخزين الأشهر بالعربية والإنجليزية
  Map<String, String> monthMap = {
    "يناير": "January",
    "فبراير": "February",
    "مارس": "March",
    "أبريل": "April",
    "مايو": "May",
    "يونيو": "June",
    "يوليو": "July",
    "أغسطس": "August",
    "سبتمبر": "September",
    "أكتوبر": "October",
    "نوفمبر": "November",
    "ديسمبر": "December"
  };

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

        // إضافة Dropdown لفلترة الفواتير حسب الأشهر
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hScreen * 0.02),
          child: DropdownButtonFormField<String>(
            hint: Text("اختر الشهر"),
            value: _selectedMonth,
            items: months.map((String month) {
              return DropdownMenuItem<String>(
                
                value: month,
                child: Text(month),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedMonth = newValue;
              });

              String? englishMonth = monthMap[newValue];
              if (englishMonth != null) {
                // هنا يمكنك إضافة كود لتحميل الفواتير وفقًا للشهر المحدد
                // مثال:
                // fetchInvoicesForMonth(englishMonth);
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
             dropdownColor: MyColors.Cardcolor,
          ),
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
}