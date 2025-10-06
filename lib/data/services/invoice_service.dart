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
 ) {
  int monthNumber = _monthToNumber[monthName] ?? 0;

  
  if (monthNumber < 1 || monthNumber > 12) {
   return Stream.value([]);
  }
    
  
  final startDate = DateTime(year, monthNumber, 1);
  final endDate = DateTime(year, monthNumber + 1, 1);
  
  
  return FirebaseFirestore.instance
    .collection('invoices')
    .where(
     'createdAt',
     isGreaterThanOrEqualTo: startDate,
    )
    .where('createdAt', isLessThan: endDate)
    .snapshots() 
    .asyncMap((invoicesSnapshot) async {
     
     
     QuerySnapshot noCommissionSnapshot = await FirebaseFirestore.instance
       .collection('invoices_without_commission')
       .get(); 

     
     final filteredNoCommission = noCommissionSnapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final dateStr = data['date'] ?? ''; 
      try {
       final parts = dateStr.split('/');
       if (parts.length == 3) {
        final month = int.tryParse(parts[1]) ?? 1; 
        final yearValue = int.tryParse(parts[2]) ?? 0;
        
        return month == monthNumber && yearValue == year;
       }
      } catch (_) {
              
            }
      return false;
     }).toList();

     
     List<QueryDocumentSnapshot> allDocs = [
      ...invoicesSnapshot.docs,
      ...filteredNoCommission,
     ];
          
     
     return allDocs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      final amountValue = data['price']?.toString() ?? '0'; 
      final invoiceNumber = data['productNumber']?.toString() ?? ''; 
      
      return InvoiceData(
       invoiceNumber: invoiceNumber,
       date: data['date'] ?? '',
       clientName: data['clientName'] ?? '',
       currency: data['currency'] ?? '',
       amount: amountValue,
       productNumber: data['productNumber']?.toString() ?? '',
      );
     }).toList();
    });
 }
}
