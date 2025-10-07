import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/cubits/expenses_cubit/expenses_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseInitial());

  Future<void> addExpense({
    required String type,
    required double amount,
    required String currency,
    required String notes,
    required String date,
  }) async {
    emit(ExpenseLoading());
    try {
      await FirebaseFirestore.instance.collection('expenses').add({
        'type': type,
        'amount': amount,
        'currency': currency,
        'notes': notes,
        'date': date,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(ExpenseSuccess());
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}