import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String? labelText;
  final String? value; 
  final List<String> items; 
  final void Function(String?)? onChanged; 

  const CustomDropdownFormField({
    Key? key,
     this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}