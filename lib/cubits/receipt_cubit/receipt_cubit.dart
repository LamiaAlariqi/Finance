import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/cubits/receipt_cubit/receipt_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  ReceiptCubit() : super(ReceiptInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = 'receipts'; 

  Future<String> generateReceiptNumber() async {
    try {
      final receipts = await _firestore
          .collection(collectionName)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (receipts.docs.isNotEmpty) {
        final lastReceiptNumberText = receipts.docs.first.data()['number'] as String? ?? 'RCPT-000';
        
        final lastNumberPart = lastReceiptNumberText.split('-').last;
        final lastNumber = int.tryParse(lastNumberPart) ?? 0;
        final newNumber = lastNumber + 1;
        
        return 'RCPT-${newNumber.toString().padLeft(3, '0')}';
      } else {
        return 'RCPT-001';
      }
    } catch (e) {
      print("Error generating receipt number: $e");
      return 'RCPT-ERROR'; 
    }
  }
  Future<void> addReceipt({
    required String clientName,
    required double amount,
    required String currency,
    required String notes,
    required String date,
    required String productNumber,
  }) async {
    emit(ReceiptLoading());
    try {
      final receiptNumber = await generateReceiptNumber();

      final receiptData = {
        'number': receiptNumber,
        'date': date,
        'clientName': clientName,
        'amount': amount,
        'currency': currency,
        'notes': notes,
        'productNumber': productNumber,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(collectionName).add(receiptData);

      emit(ReceiptSuccess());
    } catch (e) {
      emit(ReceiptError("فشل حفظ سند القبض: ${e.toString()}"));
    }
  }
}