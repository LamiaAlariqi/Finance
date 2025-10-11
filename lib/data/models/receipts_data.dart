class ReceiptData {
  final String receiptNumber;
  final String date;
  final String clientName;
  final String currency;
  final double amount;
  final String productNumber;
  final String notes;

  ReceiptData( {
    required this.notes,
    required this.receiptNumber,
    required this.date,
    required this.clientName,
    required this.currency,
    required this.amount,
    required this.productNumber,
  });
}
