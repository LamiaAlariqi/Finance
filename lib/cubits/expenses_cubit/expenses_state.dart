import 'package:equatable/equatable.dart';

abstract class ExpenseState extends Equatable {
  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);

  @override
  List<Object> get props => [message];
}