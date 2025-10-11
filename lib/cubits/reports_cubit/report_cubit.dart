import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/cubits/reports_cubit/report_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());

  final Map<String, int> _arabicMonthToNumber = {
    "يناير": 1,
    "فبراير": 2,
    "مارس": 3,
    "أبريل": 4,
    "مايو": 5,
    "يونيو": 6,
    "يوليو": 7,
    "أغسطس": 8,
    "سبتمبر": 9,
    "أكتوبر": 10,
    "نوفمبر": 11,
    "ديسمبر": 12,
  };

  // دالة مساعدة لضمان تحويل المبلغ إلى رقم عشري آمن
  double _safeParseAmount(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// لجلب التقارير الشهرية، تتطلب اسم الشهر (بالعربية) والعملة فقط.
  /// يتم استخدام السنة الحالية تلقائياً.
  void fetchMonthlyReports(String monthName, String currency) async {
    // تم إزالة 'int year'
    emit(ReportsLoading());

    try {
      int monthNumber = _arabicMonthToNumber[monthName] ?? 0;
      print(monthNumber);
      if (monthNumber < 1 || monthNumber > 12) {
        return emit(ReportsError('اسم الشهر غير صحيح أو غير متوفر.'));
      }

      // الحصول على السنة الحالية تلقائياً
      final currentYear = DateTime.now().year;

      // حساب نطاق التاريخ (من بداية الشهر إلى بداية الشهر الذي يليه).
      // يتم استخدام السنة الحالية (currentYear) بدلاً من السنة الممررة.
      final startDate = DateTime(currentYear, monthNumber, 1);
      final endDate = DateTime(currentYear, monthNumber + 1, 1);

      // 1. جلب المصروفات (Expenses)
      final expensesSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();
      print(expensesSnapshot.docs);
      // 2. جلب الفواتير (Invoices)
      final invoicesSnapshot = await FirebaseFirestore.instance
          .collection('invoices')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();

      // 3. جلب السندات (Receipts)
      final receiptsSnapshot = await FirebaseFirestore.instance
          .collection('receipts')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();
      final InvoicewithoutcomSnapshot = await FirebaseFirestore.instance
          .collection('invoices_without_commission')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();

      double totalExpenses = expensesSnapshot.docs.fold(
        0.0,
        (sum, doc) => sum + _safeParseAmount(doc.data()['amount']),
      );
      double totalInvoiceswithcom = invoicesSnapshot.docs.fold(0.0, (sum, doc) {
        double quantity = _safeParseAmount(doc.data()['quantity']);
        double price = _safeParseAmount(doc.data()['price']);
        return sum + (quantity * price);
      });

      double totalInvoiceswithoutcom = InvoicewithoutcomSnapshot.docs.fold(
        0.0,
        (sum, doc) {
          double quantity = _safeParseAmount(doc.data()['quantity']);
          double price = _safeParseAmount(doc.data()['price']);
          return sum + (quantity * price);
        },
      );
      int totalReceipts = receiptsSnapshot.docs.length;
      double totalInvoices = totalInvoiceswithoutcom + totalInvoiceswithcom;
      emit(ReportsLoaded(totalExpenses, totalInvoices, totalReceipts));
    } catch (e) {
      emit(
        ReportsError(
          'فشل في جلب التقرير الشهري. تأكد من نوع حقل "createdAt" في Firestore (يجب أن يكون Timestamp): ${e.toString()}',
        ),
      );
    }
  }

  void fetchAnnualReports(String currency, {int? year}) async {
    emit(ReportsLoading());

    try {
      final reportYear = year ?? DateTime.now().year;
      DateTime startDate = DateTime(reportYear, 1, 1);
      DateTime endDate = DateTime(reportYear + 1, 1, 1);

      final expensesSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();

      final invoicesSnapshot = await FirebaseFirestore.instance
          .collection('invoices')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();

      final receiptsSnapshot = await FirebaseFirestore.instance
          .collection('receipts')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();
      final InvoicewithoutcomSnapshot = await FirebaseFirestore.instance
          .collection('invoices_without_commission')
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThan: endDate)
          .where('currency', isEqualTo: currency)
          .get();

    double totalExpenses = expensesSnapshot.docs.fold(
        0.0,
        (sum, doc) => sum + _safeParseAmount(doc.data()['amount']),
      );
      double totalInvoiceswithcom = invoicesSnapshot.docs.fold(0.0, (sum, doc) {
        double quantity = _safeParseAmount(doc.data()['quantity']);
        double price = _safeParseAmount(doc.data()['price']);
        return sum + (quantity * price);
      });

      double totalInvoiceswithoutcom = InvoicewithoutcomSnapshot.docs.fold(
        0.0,
        (sum, doc) {
          double quantity = _safeParseAmount(doc.data()['quantity']);
          double price = _safeParseAmount(doc.data()['price']);
          return sum + (quantity * price);
        },
      );
      double totalInvoices = totalInvoiceswithoutcom + totalInvoiceswithcom;
      int totalReceipts = receiptsSnapshot.docs.length;
      emit(ReportsLoaded(totalExpenses, totalInvoices, totalReceipts));
    } catch (e) {
      emit(ReportsError('فشل في جلب التقرير السنوي: ${e.toString()}'));
    }
  }
}
