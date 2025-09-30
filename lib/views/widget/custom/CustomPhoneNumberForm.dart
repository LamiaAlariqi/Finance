import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneNumberFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomPhoneNumberFormField({
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
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('🇾🇪'), // Yemen flag emoji
            ),
            VerticalDivider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        ),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 10,
      controller: controller,
    );
  }
}