import 'package:equatable/equatable.dart';

abstract class InvoiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceSuccess extends InvoiceState {}

class InvoiceError extends InvoiceState {
  final String message;
  InvoiceError(this.message);

  @override
  List<Object?> get props => [message];
}
