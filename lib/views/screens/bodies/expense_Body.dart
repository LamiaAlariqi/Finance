import 'package:finance/data/models/Expenses_data.dart';
import 'package:finance/data/services/expenses_service.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/dialogs/expenses_dialog.dart';
import 'package:finance/views/widget/currency_drop_down.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/custom_text.dart';
import 'package:finance/views/widget/summarybox.dart';
import 'package:flutter/material.dart';

class ExpensesBody extends StatefulWidget {
  const ExpensesBody({super.key});

  @override
  State<ExpensesBody> createState() => _ExpensesBodyState();
}

class _ExpensesBodyState extends State<ExpensesBody> {
  String? _selectedMonth;
  int? _selectedYear;
  String? _selectedCurrency; 

  late final List<int> _years;
  late Stream<List<ExpenseData>> _expensesStream;

  final ExpenseService _expenseService = ExpenseService();

  final List<String> months = [
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
    "ديسمبر",
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final currentYear = now.year;

    _years = List.generate(5, (index) => currentYear - index);
    _selectedMonth = months[now.month - 1];
    _selectedYear = currentYear;
    _selectedCurrency = 'SAR';

    _expensesStream = Stream.empty();
    _updateExpensesStream();
  }

  void _updateExpensesStream() {
    if (_selectedMonth != null && _selectedYear != null && _selectedCurrency != null) {
      final englishMonth = _getEnglishMonth(_selectedMonth!);
      setState(() {
        _expensesStream = _expenseService.fetchExpensesForMonth(englishMonth, _selectedYear!, _selectedCurrency!);
      });
    }
  }

  String _getEnglishMonth(String arabicMonth) {
    const monthMap = {
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
      "ديسمبر": "December",
    };
    return monthMap[arabicMonth]!;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0), 
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: hScreen * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

        Padding(
          padding: EdgeInsets.symmetric(horizontal: hScreen * 0.02),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  hint: const Text("اختر الشهر"),
                  value: _selectedMonth,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(value: month, child: Text(month));
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMonth = newValue;
                      });
                      _updateExpensesStream();
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: MyColors.Cardcolor,
                ),
              ),

              SizedBox(width: wScreen * 0.05),

              Expanded(
                child: DropdownButtonFormField<int>(
                  hint: const Text("اختر السنة"),
                  value: _selectedYear,
                  items: _years.map((int year) {
                    return DropdownMenuItem<int>(value: year, child: Text(year.toString()));
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedYear = newValue;
                      });
                      _updateExpensesStream();
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: MyColors.Cardcolor,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: hScreen * 0.03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hScreen * 0.02),
          child: CurrencyDropdown(
            selectedCurrency: _selectedCurrency ?? 'SAR',
            onCurrencyChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCurrency = newValue;
                });
                _updateExpensesStream();
              }
            },
          ),
        ),

        SizedBox(height: hScreen * 0.03),

        StreamBuilder<List<ExpenseData>>(
          stream: _expensesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: CustomText(
                  text: "حدث خطأ في جلب البيانات: ${snapshot.error}",
                  fontSize: fSize * 0.8,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              );
            }

            final expenses = snapshot.data ?? [];
            final totalAmount = expenses.fold<double>(
              0,
              (sum, item) => sum + item.amount,
            );

            double highestExpense = 0;
            if (expenses.isNotEmpty) {
              highestExpense = expenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SummaryBox(
                        color: Colors.blue[100],
                        icon: Icons.summarize,
                        label: 'الاجمالي ',
                        value: totalAmount.toString(),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: SummaryBox(
                        color: Colors.green[100],
                        icon: Icons.trending_up,
                        label: 'أعلى مصروف',
                        value: highestExpense.toString(),
                      ),
                    ),
                  ],
                ),
                ...expenses.map((expense) => ListTile(
                  leading: Icon(Icons.money_off, color: Colors.red[400]),
                  title: Text("مصروف: ${expense.type}"),
                  subtitle: Text("${expense.date} | ${expense.amount} ${expense.currency}"),
                  trailing: Text("${expense.amount}"),
                )).toList(),
              ],
            );
          },
        ),
      ],
    );
  }
}