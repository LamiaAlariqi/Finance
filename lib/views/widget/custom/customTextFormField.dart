import 'package:finance/res/sizes.dart';
import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.suffixIcon,
    required this.obscureText,
    required this.keyboardType,
    required this.enabledBorderColor,
    required this.focusedBorderColor,
    required this.controller,
    this.readOnly = false,
    this.notSignIn = true,
    this.onSaved,
    this.suffixIconColor = Colors.grey,
    this.textAlign,
    this.width,
    this.fsize,
    this.showBorder = true, 
  });

  final String hintText;
  final TextAlign? textAlign;
  final IconData suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final TextEditingController controller;
  final bool readOnly;
  final bool notSignIn;
  final void Function(String?)? onSaved;
  final Color suffixIconColor;
  final double? width;
  final double? fsize;
  final bool showBorder; 

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: (value) {
        if (value!.isNotEmpty) {
          if (obscureText && notSignIn) {
           
            if (value.length > 8) {
              return null;
            } else {
              return "يجب أن يكون طول كلمة المرور 8 أحرف على الأقل";
            }
          } else {
            // التحقق من صحة البريد الإلكتروني
            if (keyboardType == TextInputType.emailAddress) {
              final RegExp emailRegex = RegExp(
                r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
              );
              if (emailRegex.hasMatch(value)) {
                return null;
              } else {
                return "عنوان البريد الإلكتروني الذي أدخلته غير صحيح";
              }
            } else {
              return null;
            }
          }
        } else if (value.isEmpty) {
          return "هذا الحقل مطلوب";
        } else {
          return null;
        }
      },
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: hintText,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: fsize ?? fSize * 1,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: Icon(
          suffixIcon,
          color: suffixIconColor,
        ),
        border: showBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(wScreen * .04),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColorLight,
          ),
        ) : null,
        enabledBorder: showBorder ? OutlineInputBorder(
          borderSide: BorderSide(
            color: enabledBorderColor,
            width: width ?? 3,
          ),
          borderRadius: BorderRadius.circular(wScreen * .04),
        ) : null,
        focusedBorder: showBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(wScreen * .04),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: width ?? 2.5,
          ),
        ) : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: wScreen * .05,
          vertical: hScreen * .01,
        ),
      ),
    );
  }
}