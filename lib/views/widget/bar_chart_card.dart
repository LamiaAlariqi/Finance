import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance/cubits/reports_cubit/report_state.dart'; // ReportsLoaded
import 'package:finance/res/sizes.dart'; // hScreen, fSize

class BarChartCard extends StatelessWidget {
  final ReportsLoaded loadedState;

  const BarChartCard({super.key, required this.loadedState});

  // 🌟 دالة مساعدة لتبسيط الأرقام على المحور Y
  String _getAxisText(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  // 🌟 ويدجت مساعدة لعرض عنصر الأسطورة
  Widget _LegendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(hScreen * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مقارنة المبيعات والمصروفات والربح",
              style: TextStyle(
                fontSize: fSize * 0.9,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: hScreen * 0.02),
            Row(
              children: [
                _LegendItem(color: Colors.green, text: "المبيعات"),
                const SizedBox(width: 10),
                _LegendItem(color: Colors.orange, text: "المصروفات"),
                const SizedBox(width: 10),
                _LegendItem(color: Colors.blue, text: "الربح"),
                const SizedBox(width: 10),
                _LegendItem(color: Colors.red, text: "خسارة"),
              ],
            ),
            SizedBox(height: hScreen * 0.03),

            if (loadedState.totalInvoices == 0 && loadedState.totalExpenses == 0)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: hScreen * 0.05),
                  child: Text(
                    "لا توجد بيانات لهذا الشهر",
                    style: TextStyle(
                      fontSize: fSize * 0.8,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: hScreen * 0.4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final netProfit =
                        loadedState.totalInvoices - loadedState.totalExpenses;

                    final maxAbsoluteValue = [
                      loadedState.totalInvoices.abs(),
                      loadedState.totalExpenses.abs(),
                      netProfit.abs(),
                      10.0 
                    ].reduce((a, b) => a > b ? a : b);

                    final maxY = maxAbsoluteValue * 1.1; 
                    final minY = -maxAbsoluteValue * 1.1;
                    final fixedInterval = (maxY - minY) / 4; 

                    return BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        minY: minY,
                        
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          horizontalInterval: fixedInterval,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: value == 0 ? Colors.black : Colors.grey.withOpacity(0.3),
                              strokeWidth: value == 0 ? 1.5 : 0.5,
                              dashArray: value == 0 ? null : [2, 2],
                            );
                          },
                        ),
                        
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                              interval: fixedInterval,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  _getAxisText(value), // استخدام دالة تبسيط الأرقام
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.right,
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text('المبيعات', style: TextStyle(fontSize: 12));
                                  case 1:
                                    return const Text('المصروفات', style: TextStyle(fontSize: 12));
                                  case 2:
                                    return const Text('الربح/الخسارة', style: TextStyle(fontSize: 12));
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        
                        borderData: FlBorderData(show: false),
                        
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toStringAsFixed(2)}', 
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                        
                        barGroups: [
                          // ... Bar Groups Code as before ...
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: loadedState.totalInvoices,
                                gradient: const LinearGradient(
                                    colors: [Colors.greenAccent, Colors.green]),
                                width: 30,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: loadedState.totalExpenses,
                                gradient:
                                    const LinearGradient(colors: [Colors.orange, Colors.red]),
                                width: 30,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: netProfit,
                                gradient: LinearGradient(
                                  colors: netProfit >= 0
                                      ? [Colors.lightBlueAccent, Colors.blue]
                                      : [Colors.deepOrangeAccent, Colors.red[800]!], 
                                ),
                                width: 30,
                                fromY: 0, 
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}