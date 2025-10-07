import 'package:flutter/material.dart';

class CurrencyDropdown extends StatefulWidget {
  final String selectedCurrency;
  final ValueChanged<String?> onCurrencyChanged;

  const CurrencyDropdown({
    Key? key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  }) : super(key: key);

  @override
  State<CurrencyDropdown> createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedCurrency,
      items: const [
        DropdownMenuItem(value: 'SAR', child: Text('ريال سعودي')),
        DropdownMenuItem(value: 'USD', child: Text('دولار أمريكي')),
        DropdownMenuItem(value: 'YER', child: Text('ريال يمني')),
      ],
      onChanged: widget.onCurrencyChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}