class InvoiceData {
  final String invoiceNumber;
  final String date;
  final String clientName;
  final String currency;
  final String amount;
  final String productNumber;
   final double price;
   final int quantity;
    final double commission;
     final String  notes;
     final String category;

  InvoiceData( {
    required this.invoiceNumber,
    required this.date,
    required this.clientName,
    required this.currency,
    required this.amount,
    required this.productNumber,
    required this.category,
    required this.price, required this.quantity, required this.commission, required this.notes,
  });
}