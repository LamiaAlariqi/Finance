import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/data/models/invoice_data.dart';

class InvoiceService {
  Future<List<InvoiceData>> fetchInvoicesForMonth(String month, int year) async {
    Map<String, int> monthToNumber = {
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

    int monthNumber = monthToNumber[month] ?? 0;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('invoices')
        .where('createdAt', isGreaterThanOrEqualTo: DateTime(year, monthNumber, 1))
        .where('createdAt', isLessThan: DateTime(year, monthNumber + 1, 1))
        .get();

    return snapshot.docs.map((doc) {
      return InvoiceData(
        invoiceNumber: doc['number'] ?? '',
        date: doc['date'] ?? '',
        clientName: doc['clientName'] ?? '',
        currency: doc['currency'] ?? '',
        amount: doc['totalAmount']?.toString() ?? '0',
        productNumber: doc['number'] ?? '', 
      );
    }).toList();
  }
}