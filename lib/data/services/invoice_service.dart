import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/data/models/invoice_data.dart';

class InvoiceService {

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

  Stream<List<InvoiceData>> fetchAllInvoicesForMonth(
    String monthName,
    int year,
    String currency,
  ) {
    int monthNumber = _monthToNumber[monthName] ?? 0;

    if (monthNumber < 1 || monthNumber > 12) {
      return Stream.value([]);
    }

    final startDate = DateTime(year, monthNumber, 1);
    final endDate = DateTime(year, monthNumber + 1, 1);

    final invoicesStream = FirebaseFirestore.instance
        .collection('invoices')
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .where('currency', isEqualTo: currency)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return invoicesStream.asyncMap((invoicesSnapshot) async {
      QuerySnapshot noCommissionSnapshot =
          await FirebaseFirestore.instance.collection('invoices_without_commission').get();

      final filteredNoCommission = noCommissionSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        final timestamp = data['createdAt'] as Timestamp?;
        final docCurrency = data['currency'] ?? '';
        
        if (timestamp != null) {
          final docDate = timestamp.toDate();
          return docDate.year == year && 
                 docDate.month == monthNumber &&
                 docCurrency == currency;
        }
        return false;
      }).toList();

      List<QueryDocumentSnapshot> allDocs = [
        ...invoicesSnapshot.docs,
        ...filteredNoCommission,
      ];
      
      allDocs.sort((a, b) {
        final aTimestamp = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
        final bTimestamp = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
        final aDate = aTimestamp?.toDate() ?? DateTime(0);
        final bDate = bTimestamp?.toDate() ?? DateTime(0);
        return bDate.compareTo(aDate);
      });

      return allDocs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final amountValue = data['price']?.toString() ?? '0';
        final invoiceNumber = data['productNumber']?.toString() ?? '';
        
        final dateTimestamp = data['createdAt'] as Timestamp?;
        final dateString = dateTimestamp != null 
                           ? "${dateTimestamp.toDate().day}/${dateTimestamp.toDate().month}/${dateTimestamp.toDate().year}" 
                           : (data['date'] ?? '');

        return InvoiceData(
          invoiceNumber: invoiceNumber,
          date: dateString, 
          clientName: data['clientName'] ?? '',
          currency: data['currency'] ?? '',
          amount: amountValue,
          productNumber: data['productNumber']?.toString() ?? '',
           category: data['category'],
            price: data['price'], 
           quantity: (data['quantity'] as num?)?.toInt() ?? 0,
            commission: data['commission'] ?? 0.0,
            notes: data['notes']
        );
      }).toList();
    });
  }

  Future<int> countDocumentsInBothCollections() async {
    final invoicesSnapshot = await FirebaseFirestore.instance.collection('invoices').get();
    final noCommissionSnapshot = await FirebaseFirestore.instance.collection('invoices_without_commission').get();
    final totalDocuments = invoicesSnapshot.docs.length + noCommissionSnapshot.docs.length;

    return totalDocuments;
  }
}