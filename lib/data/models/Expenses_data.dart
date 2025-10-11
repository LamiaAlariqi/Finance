import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseData {
  final String type;
  final double amount;
  final String currency;
  final String notes;
  final String date;
  final DateTime createdAt; 
  final String? description;
  ExpenseData({
    this.description,
    required this.type,
    required this.amount,
    required this.currency,
    required this.notes,
    required this.date,
    required this.createdAt,
  });

  factory ExpenseData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseData(
      type: data['type'],
      amount: (data['amount'] as num).toDouble(),
      currency: data['currency'],
      notes: data['notes'],
      date: data['date'],
      createdAt: (data['createdAt'] as Timestamp).toDate(), 
      description: data['notes']
    );
  }
}

