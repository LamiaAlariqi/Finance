class ReceiptData {
  final String receiptNumber;
  final String date;
  final String clientName;
  final String currency;
  final double amount; // يجب أن يكون double أو num ليتطابق مع InvoiceCard
  final String productNumber;

  ReceiptData({
    required this.receiptNumber,
    required this.date,
    required this.clientName,
    required this.currency,
    required this.amount,
    required this.productNumber,
  });
}
