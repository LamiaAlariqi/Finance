 import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/customTextFormField.dart';
import 'package:flutter/material.dart';


class ExpenseDialog extends StatefulWidget {
  const ExpenseDialog({super.key});

  @override
  State<ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<ExpenseDialog> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedCurrency = 'SAR';

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = _formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: wScreen * 0.8,
          padding: EdgeInsets.all(hScreen * 0.02),
          color: MyColors.Cardcolor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== العنوان =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إضافة مصروف جديد',
                      style: TextStyle(
                          fontSize: fSize * 0.9, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ===== التاريخ =====
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      hintText: "التاريخ",
                      suffixIcon: Icons.calendar_today,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      readOnly: true,
                      width: 1,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ===== نوع المصروف =====
                CustomTextFormField(
                  hintText: "نوع المصروف",
                  suffixIcon: Icons.category,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: _typeController,
                  width: 1,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  suffixIconColor: Colors.grey,
                ),
                const SizedBox(height: 16),

                // ===== المبلغ + العملة =====
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "المبلغ",
                        suffixIcon: Icons.attach_money,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        controller: _amountController,
                        width: 1,
                        enabledBorderColor: MyColors.kmainColor,
                        focusedBorderColor: MyColors.kmainColor,
                        suffixIconColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _buildCurrencyDropdown()),
                  ],
                ),
                const SizedBox(height: 16),

                // ===== الوصف =====
                CustomTextFormField(
                  hintText: "الوصف",
                  suffixIcon: Icons.note,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  controller: _notesController,
                  width: 1,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  suffixIconColor: Colors.grey,
                ),
                const SizedBox(height: 20),

                // ===== زر الحفظ =====
                Align(
                  alignment: Alignment.bottomLeft,
                  child: CustomMaterialButton(
                    title: "حفظ",
                    vertical: hScreen * 0.01,
                    buttonColor: MyColors.kmainColor,
                    textColor: Colors.white,
                    borderWidth: 0.5,
                    borderColor: MyColors.kmainColor,
                    height: hScreen * 0.05,
                    width: wScreen * 0.25,
                    textsize: fSize * 0.9,
                    onPressed: () {
                      // منطق الحفظ هنا
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCurrency,
      items: [
        DropdownMenuItem(
            value: 'SAR',
            child: Text('ريال سعودي', style: TextStyle(fontSize: fSize * 0.8))),
        DropdownMenuItem(
            value: 'USD',
            child: Text('دولار أمريكي', style: TextStyle(fontSize: fSize * 0.8))),
        DropdownMenuItem(
            value: 'YER',
            child: Text('ريال يمني', style: TextStyle(fontSize: fSize * 0.8))),
      ],
      onChanged: (String? newValue) {
        setState(() {
          _selectedCurrency = newValue!;
        });
      },
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}
