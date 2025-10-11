import 'package:flutter/material.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/custom_text.dart';

class ReportFilters extends StatelessWidget {
  final String reportType;
  final String? selectedMonth;
  final int? selectedYear;
  final String selectedCurrency;
  final List<String> currencies;
  final List<String> months;
  final List<int> years;
  final Function(String) onReportTypeChanged;
  final Function(String) onMonthChanged;
  final Function(int) onYearChanged;
  final Function(String) onCurrencyChanged;

  const ReportFilters({
    super.key,
    required this.reportType,
    required this.selectedMonth,
    required this.selectedYear,
    required this.selectedCurrency,
    required this.currencies,
    required this.months,
    required this.years,
    required this.onReportTypeChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "التقارير",
              fontSize: fSize * 0.9,
              fontWeight: FontWeight.bold,
              color: MyColors.appTextColorPrimary,
            ),
            CustomText(
              text: "تقارير مالية شاملة",
              fontSize: fSize * 0.8,
              fontWeight: FontWeight.normal,
              color: MyColors.appTextColorPrimary,
            ),
          ],
        ),
        Row(
          children: [
            // 🔹 نوع التقرير
            DropdownButton<String>(
              value: reportType,
              items: ["شهري", "سنوي"].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type, style: TextStyle(fontSize: fSize * 0.8)),
                );
              }).toList(),
              onChanged: (newValue) => onReportTypeChanged(newValue!),
            ),
            SizedBox(width: wScreen * 0.02),

            // 🔹 الشهر (إذا كان شهري)
            if (reportType == "شهري")
              DropdownButton<String>(
                value: selectedMonth,
                hint: const Text("اختر الشهر"),
                items: months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month, style: TextStyle(fontSize: fSize * 0.8)),
                  );
                }).toList(),
                onChanged: (newValue) => onMonthChanged(newValue!),
              ),

            // 🔹 السنة (إذا كان سنوي)
            if (reportType == "سنوي")
              DropdownButton<int>(
                value: selectedYear,
                items: years.map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString(), style: TextStyle(fontSize: fSize * 0.8)),
                  );
                }).toList(),
                onChanged: (newValue) => onYearChanged(newValue!),
              ),

            SizedBox(width: wScreen * 0.02),

            // 🔹 اختيار العملة
            DropdownButton<String>(
              value: selectedCurrency,
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: fSize * 0.8)),
                );
              }).toList(),
              onChanged: (newValue) => onCurrencyChanged(newValue!),
            ),
          ],
        ),
      ],
    );
  }
}