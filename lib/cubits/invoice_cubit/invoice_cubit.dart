import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String> generateInvoiceNumber() async {
    final invoices = await _firestore
        .collection('invoices')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (invoices.docs.isNotEmpty) {
      final lastInvoiceData = invoices.docs.first.data();
      final lastInvoiceNumberText = lastInvoiceData['number'] as String? ?? 'INV-000';
      final lastNumberPart = lastInvoiceNumberText.split('-').last;
      final lastNumber = int.tryParse(lastNumberPart) ?? 0;
      final newNumber = lastNumber + 1;
      return 'INV-${newNumber.toString().padLeft(3, '0')}';
    } else {
      return 'INV-001';
    }
  }

  Future<void> addInvoice({
    required String clientName,
    required String productNumber,
    required String category,
    required double price,
    required double quantity,
    required String currency,
    required String notes,
    required String date,
  }) async {
    emit(InvoiceLoading());
    try {
      
      final invoiceNumber = await generateInvoiceNumber();
      final totalAmount = price * quantity; 
      final commission = totalAmount * 0.10;
      final customerReceived = totalAmount - commission;
      final invoiceData = {
        'number': invoiceNumber, 
        'date': date,
        'clientName': clientName,
        'category': category,
        'price': price,
        'quantity': quantity.toInt(),
        'currency': currency,
        'notes': notes,
        'totalAmount': totalAmount,
        'commission': commission,
        'customerReceived': customerReceived, 
        'productNumber':productNumber,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('invoices').add(invoiceData);

      emit(InvoiceSuccess());
    } catch (e) {
      emit(InvoiceError("فشل حفظ الفاتورة: ${e.toString()}"));
    }
  }
}