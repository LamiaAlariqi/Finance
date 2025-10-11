import 'package:finance/cubits/reports_cubit/report_cubit.dart';
import 'package:finance/cubits/reports_cubit/report_state.dart';
import 'package:finance/views/widget/bar_chart_card.dart';
import 'package:finance/views/widget/reports_filter.dart';
import 'package:finance/views/widget/summary_boxes_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance/res/sizes.dart'; 

class ReportsBody extends StatefulWidget {
  const ReportsBody({super.key});

  @override
  State<ReportsBody> createState() => _ReportsBodyState();
}

class _ReportsBodyState extends State<ReportsBody> {
  String _selectedCurrency = "YER";
  String? _selectedMonth;
  int? _selectedYear;
  String _reportType = "شهري";

  final List<String> _currencies = ["YER", "USD", "SAR"];
  final List<String> _months = [
    "يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
  ];
  final List<int> _years =
      List.generate(5, (index) => DateTime.now().year - index);

  @override
  void initState() {
    super.initState();
    _selectedMonth = _months[DateTime.now().month - 1];
    _selectedYear = DateTime.now().year;
  }

  // دالة مساعدة لجلب البيانات (لتجنب التكرار في onChanged)
  void _fetchReports(ReportsCubit cubit) {
    if (_reportType == "شهري" && _selectedMonth != null) {
      cubit.fetchMonthlyReports(_selectedMonth!, _selectedCurrency);
    } else if (_reportType == "سنوي" && _selectedYear != null) {
      cubit.fetchAnnualReports(_selectedCurrency, year: _selectedYear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsCubit(),
      child: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          if (state is ReportsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildReportContent(context, state);
        },
      ),
    );
  }

  Widget _buildReportContent(BuildContext context, ReportsState state) {
    final cubit = BlocProvider.of<ReportsCubit>(context);

    if (state is ReportsInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchReports(cubit);
      });
    }

    final isLoaded = state is ReportsLoaded;
    final ReportsLoaded? loadedState = isLoaded ? state as ReportsLoaded : null;

    return ListView(
      padding: EdgeInsets.all(hScreen * 0.02),
      children: [
        ReportFilters(
          reportType: _reportType,
          selectedMonth: _selectedMonth,
          selectedYear: _selectedYear,
          selectedCurrency: _selectedCurrency,
          currencies: _currencies,
          months: _months,
          years: _years,
          onReportTypeChanged: (newValue) {
            setState(() {
              _reportType = newValue;
              _fetchReports(cubit);
            });
          },
          onMonthChanged: (newValue) {
            setState(() {
              _selectedMonth = newValue;
              _fetchReports(cubit);
            });
          },
          onYearChanged: (newValue) {
            setState(() {
              _selectedYear = newValue;
              _fetchReports(cubit);
            });
          },
          onCurrencyChanged: (newValue) {
            setState(() {
              _selectedCurrency = newValue;
              _fetchReports(cubit);
            });
          },
        ),
        SizedBox(height: hScreen * 0.03),

        if (state is ReportsError)
          Center(
            child: Text('خطأ: ${(state as ReportsError).message}',
                style: const TextStyle(color: Colors.red)),
          ),

        if (isLoaded) ...[
          SummaryBoxesGrid(loadedState: loadedState!),
          SizedBox(height: hScreen * 0.04),
          BarChartCard(loadedState: loadedState),
        ],
      ],
    );
  }
}