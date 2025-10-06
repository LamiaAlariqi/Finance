class InvoiceData {
  final String invoiceNumber;
  final String date;
  final String clientName;
  final String currency;
  final String amount;
  final String productNumber;

  InvoiceData({
    required this.invoiceNumber,
    required this.date,
    required this.clientName,
    required this.currency,
    required this.amount,
    required this.productNumber,
  });
}