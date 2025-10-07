import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/data/models/Expenses_data.dart';

class ExpenseService {
  final Map<String, int> _monthToNumber = {
    "January": 1,
    "February": 2,
    "March": 3,
    "April": 4,
    "May": 5,
    "June": 6,
    "July": 7,
    "August": 8,
    "September": 9,
    "October": 10,
    "November": 11,
    "December": 12,
  };

  CollectionReference<Map<String, dynamic>> get _expensesCollection {
    return FirebaseFirestore.instance.collection('expenses');
  }

  // تعديل الفلترة حسب العملة
  Stream<List<ExpenseData>> fetchExpensesForMonth(String monthName, int year, String currency) {
    int monthNumber = _monthToNumber[monthName] ?? 0;

    if (monthNumber < 1 || monthNumber > 12) {
      return Stream.value([]);
    }

    final startDate = DateTime(year, monthNumber, 1);
    final endDate = DateTime(year, monthNumber + 1, 1);

    return _expensesCollection
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .where('currency', isEqualTo: currency)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ExpenseData.fromFirestore(doc);
          }).toList();
        });
  }

  // تعديل الفلترة حسب العملة
  Future<double> fetchTotalExpensesForMonth(String monthName, int year, String currency) async {
    int monthNumber = _monthToNumber[monthName] ?? 0;

    if (monthNumber < 1 || monthNumber > 12) {
      return 0;
    }

    final startDate = DateTime(year, monthNumber, 1);
    final endDate = DateTime(year, monthNumber + 1, 1);

    final snapshot = await _expensesCollection
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .where('currency', isEqualTo: currency) // إضافة شرط العملة
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['amount'] as num).toDouble();
    }
    return total;
  }

  // تعديل الفلترة حسب العملة
  Future<double> fetchHighestExpenseForMonth(String monthName, int year, String currency) async {
    int monthNumber = _monthToNumber[monthName] ?? 0;

    if (monthNumber < 1 || monthNumber > 12) {
      return 0;
    }

    final startDate = DateTime(year, monthNumber, 1);
    final endDate = DateTime(year, monthNumber + 1, 1);

    final snapshot = await _expensesCollection
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .where('currency', isEqualTo: currency) // إضافة شرط العملة
        .orderBy('amount', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return (snapshot.docs.first.data()['amount'] as num).toDouble();
    }
    return 0;
  }

  Future<int> countAllExpenses() async {
    final snapshot = await _expensesCollection.get();
    return snapshot.docs.length; 
  }
}