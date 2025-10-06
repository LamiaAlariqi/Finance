import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/data/models/receipts_data.dart';

class ReceiptService {


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

  CollectionReference<Map<String, dynamic>> get _receiptsCollection {
    return 
     FirebaseFirestore.instance.collection('receipts');
  }

  Stream<List<ReceiptData>> fetchAllReceiptsForMonth(
    String monthName,
    int year,
  ) {
    int monthNumber = _monthToNumber[monthName] ?? 0;

    if (monthNumber < 1 || monthNumber > 12) {
      return Stream.value([]);
    }

    final startDate = DateTime(year, monthNumber, 1);
    final endDate = DateTime(year, monthNumber + 1, 1);

    return _receiptsCollection
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: startDate,
        )
        .where('createdAt', isLessThan: endDate)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();

            final amountValue = (data['amount'] as num?)?.toDouble() ?? 0.0;
            final receiptNumber = data['number'] ?? '';
            final dateString = data['date'] ?? '';

            return ReceiptData(
              receiptNumber: receiptNumber,
              date: dateString,
              clientName: data['clientName'] ?? '',
              currency: data['currency'] ?? '',
              amount: amountValue,
              productNumber: data['productNumber'] ?? '',
            );
          }).toList();
        });
  }
}
