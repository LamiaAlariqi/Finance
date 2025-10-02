import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String date;
  final String clientName;
  final String currency;
  final String amount;
  final String service;
  final void Function()? onPressed;

  const InvoiceCard({
    super.key,
    required this.invoiceNumber,
    required this.date,
    required this.clientName,
    required this.currency,
    required this.amount,
    required this.service,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: MyColors.Cardcolor,
        margin: EdgeInsets.symmetric(
          horizontal: wScreen * 0.02,
          vertical: hScreen * 0.01,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(hScreen * 0.015),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    invoiceNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fSize * 0.8,
                    ),
                  ),
                  Text(date, style: TextStyle(fontSize: fSize * 0.7)),
                  Text(
                    "العميل: $clientName",
                    style: TextStyle(fontSize: fSize * 0.7),
                  ),
                  Text(service, style: TextStyle(fontSize: fSize * 0.7)),
                  SizedBox(height: hScreen * 0.01),
                  Container(
                    height: hScreen * 0.048,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: wScreen * 0.03,
                          vertical: hScreen * 0.01,
                        ),
                      ),
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.check,
                        size: fSize * 0.8,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "تم السداد",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$currency $amount",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "$currency $amount",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
