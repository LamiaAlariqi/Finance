import 'package:flutter/material.dart';

class CustomDatePickerFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomDatePickerFormField({
    Key? key,
    required this.labelText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formattedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
          controller.text = formattedDate; 
        }
      },
      controller: controller,
    );
  }
}