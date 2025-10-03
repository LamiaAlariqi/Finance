import 'package:flutter/material.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsBody extends StatefulWidget {
  const ReportsBody({super.key});

  @override
  State<ReportsBody> createState() => _ReportsBodyState();
}

class _ReportsBodyState extends State<ReportsBody> {
  String _selectedCurrency = "ريال سعودي";
  String _selectedDateFilter = "هذا الشهر";

  final List<String> _currencies = ["ريال سعودي", "ريال يمني", "دولار"];
  final List<String> _dateFilters = ["اليوم", "هذا الأسبوع", "هذا الشهر", "هذه السنة"];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(hScreen * 0.02),
      children: [
        // ===== العنوان =====
        Row(
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
                // فلترة التاريخ
                DropdownButton<String>(
                  value: _selectedDateFilter,
                  items: _dateFilters.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: fSize * 0.8)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDateFilter = newValue!;
                    });
                  },
                ),
                SizedBox(width: wScreen * 0.02),
                // فلترة العملات
                DropdownButton<String>(
                  value: _selectedCurrency,
                  items: _currencies.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: fSize * 0.8)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCurrency = newValue!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: hScreen * 0.03),

        // ===== Summary Boxes 
        Row(
          children: [
            Expanded(
              child: SummaryBox(
                color: Colors.green[100],
                icon: Icons.shopping_cart,
                label: 'إجمالي المبيعات',
                value: '0',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: SummaryBox(
                color: Colors.red[100],
                icon: Icons.money_off,
                label: 'إجمالي المصروفات',
                value: '0',
              ),
            ),
          ],
        ),
        SizedBox(height: hScreen*0.015),
        Row(
          children: [
            Expanded(
              child: SummaryBox(
                color: Colors.blue[100],
                icon: Icons.receipt,
                label: 'إجمالي السندات',
                value: '0',
              ),
            ),
            SizedBox(width: hScreen*0.015),
            Expanded(
              child: SummaryBox(
                color: Colors.purple[100],
                icon: Icons.show_chart,
                label: 'صافي الربح',
                value: '0',
              ),
            ),
          ],
        ),

        SizedBox(height: hScreen * 0.04),

        // ===== مخطط المقارنة =====
        Card(
          color: Colors.grey[100], 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(hScreen * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("مقارنة المبيعات والمصروفات", style: TextStyle(fontSize: fSize * 0.9, fontWeight: FontWeight.bold)),
                SizedBox(height: hScreen * 0.02),

              
                Row(
                  children: const [
                    _LegendItem(color: Colors.blue, text: "الربح"),
                    SizedBox(width: 10),
                    _LegendItem(color: Colors.red, text: "المصروفات"),
                    SizedBox(width: 10),
                    _LegendItem(color: Colors.green, text: "المبيعات"),
                  ],
                ),
                SizedBox(height: hScreen * 0.02),

                SizedBox(
                  height: hScreen * 0.3,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 6)],
                          isCurved: true,
                          color: Colors.blue, // الربح
                          barWidth: 3,
                        ),
                        LineChartBarData(
                          spots: [FlSpot(0, 2), FlSpot(1, 3), FlSpot(2, 5)],
                          isCurved: true,
                          color: Colors.red, // المصروفات
                          barWidth: 3,
                        ),
                        LineChartBarData(
                          spots: [FlSpot(0, 4), FlSpot(1, 6), FlSpot(2, 7)],
                          isCurved: true,
                          color: Colors.green, // المبيعات
                          barWidth: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: hScreen * 0.04),

        // ===== مخطط توزيع المصروفات =====
        Card(
          color: Colors.grey[100], // الخلفية الرمادية
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(hScreen * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("توزيع المصروفات", style: TextStyle(fontSize: fSize * 0.9, fontWeight: FontWeight.bold)),
                SizedBox(height: hScreen * 0.02),
                SizedBox(
                  height: hScreen * 0.3,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: 40, color: Colors.orange, title: "تشغيل"),
                        PieChartSectionData(value: 30, color: Colors.red, title: "رواتب"),
                        PieChartSectionData(value: 20, color: Colors.green, title: "خدمات"),
                        PieChartSectionData(value: 10, color: Colors.blue, title: "أخرى"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ويدجت خاصة لعرض التوضيح (Legend) تحت العنوان
class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
