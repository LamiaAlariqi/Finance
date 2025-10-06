import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  InvoiceCubit() : super(InvoiceInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// توليد رقم الفاتورة الجديد
  Future<String> generateInvoiceNumber() async {
    final invoices = await _firestore
        .collection('invoices')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (invoices.docs.isNotEmpty) {
      final lastInvoiceData = invoices.docs.first.data();
      final lastInvoiceNumberText =
          lastInvoiceData['number'] as String? ?? 'INV-000';
      final lastNumberPart = lastInvoiceNumberText.split('-').last;
      final lastNumber = int.tryParse(lastNumberPart) ?? 0;
      final newNumber = lastNumber + 1;
      return 'INV-${newNumber.toString().padLeft(3, '0')}';
    } else {
      return 'INV-001';
    }
  }

  /// 🔹 دوال الحساب (تُستخدم داخل الكيوبت أو من الواجهة مباشرة)
  double calculateTotal(double price, double quantity) {
    return price * quantity;
  }

  double calculateCommission(double price, double quantity) {
    final total = calculateTotal(price, quantity);
    return total * 0.10;
  }

  double calculateCustomerReceived(double price, double quantity) {
    final total = calculateTotal(price, quantity);
    final commission = calculateCommission(price, quantity);
    return total - commission;
  }

  /// 🔹 إضافة فاتورة مع العمولة
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
      final totalAmount = calculateTotal(price, quantity);
      final commission = calculateCommission(price, quantity);
      final customerReceived = calculateCustomerReceived(price, quantity);

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
        'productNumber': productNumber,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('invoices').add(invoiceData);

      emit(InvoiceSuccess());
    } catch (e) {
      emit(InvoiceError("فشل حفظ الفاتورة: ${e.toString()}"));
    }
  }

  /// 🔹 إضافة فاتورة بدون عمولة
  Future<void> addInvoiceWithoutCommission({
    required String clientName,
    required String category,
    required double price,
    required double quantity,
    required String currency,
    required String notes,
    required String date,
    required String productNumber,
    required double receivedAmount,
  }) async {
    try {
      await _firestore.collection('invoices_without_commission').add({
        'clientName': clientName,
        'category': category,
        'price': price,
        'quantity': quantity,
        'currency': currency,
        'notes': notes,
        'date': date,
        'productNumber': productNumber,
        'receivedAmount': receivedAmount,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(InvoiceSuccess());
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}
