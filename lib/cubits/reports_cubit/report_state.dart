abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final double totalExpenses;
  final double totalInvoices;
  final int totalReceipts;

  ReportsLoaded(this.totalExpenses, this.totalInvoices, this.totalReceipts);
}

class ReportsError extends ReportsState {
  final String message;
  ReportsError(this.message);
}
