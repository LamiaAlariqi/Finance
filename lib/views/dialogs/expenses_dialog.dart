import 'package:finance/cubits/expenses_cubit/expenses_cubit.dart';
import 'package:finance/functions/printExpense.dart';
import 'package:finance/res/color_app.dart';
import 'package:finance/res/sizes.dart';
import 'package:finance/views/widget/currency_drop_down.dart';
import 'package:finance/views/widget/custom/customButton.dart';
import 'package:finance/views/widget/custom/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  bool _isLoading = false; // حالة التحميل

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

  void _saveExpense({bool printAfterSave = false}) async {
    if (_typeController.text.isEmpty || _amountController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true; // تفعيل حالة التحميل
    });

    final cubit = context.read<ExpenseCubit>();
    final amount = double.tryParse(_amountController.text) ?? 0;

    await cubit.addExpense(
      type: _typeController.text,
      amount: amount,
      currency: _selectedCurrency,
      notes: _notesController.text,
      date: _dateController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حفظ المصروف بنجاح!'),
        duration: const Duration(seconds: 2),
      ),
    );

    if (printAfterSave) {
      printExpense(
        date: _dateController.text,
        type: _typeController.text,
        amount: double.tryParse(_amountController.text) ?? 0,
        currency: _selectedCurrency,
        description: _notesController.text,
      );
    }

    setState(() {
      _isLoading = false; // إلغاء تفعيل حالة التحميل
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: wScreen * 0.8,
          padding: EdgeInsets.all(hScreen * 0.02),
          color: MyColors.Cardcolor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'إضافة مصروف جديد',
                      style: TextStyle(
                        fontSize: fSize * 0.9,
                        fontWeight: FontWeight.bold,
                      ),
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
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      hintText: "التاريخ",
                      suffixIcon: Icons.calendar_today,
                      controller: _dateController,
                      readOnly: true,
                      width: 1,
                      enabledBorderColor: MyColors.kmainColor,
                      focusedBorderColor: MyColors.kmainColor,
                      suffixIconColor: Colors.grey,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ===== نوع المصروف =====
                CustomTextFormField(
                  hintText: "نوع المصروف",
                  suffixIcon: Icons.category,
                  controller: _typeController,
                  width: 1,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  suffixIconColor: Colors.grey,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),

                // ===== المبلغ + العملة =====
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "المبلغ",
                        suffixIcon: Icons.attach_money,
                        controller: _amountController,
                        width: 1,
                        enabledBorderColor: MyColors.kmainColor,
                        focusedBorderColor: MyColors.kmainColor,
                        suffixIconColor: Colors.grey,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CurrencyDropdown(
                        selectedCurrency: _selectedCurrency,
                        onCurrencyChanged: (newValue) {
                          setState(() {
                            _selectedCurrency = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ===== الوصف =====
                CustomTextFormField(
                  hintText: "الوصف",
                  suffixIcon: Icons.note,
                  controller: _notesController,
                  width: 1,
                  enabledBorderColor: MyColors.kmainColor,
                  focusedBorderColor: MyColors.kmainColor,
                  suffixIconColor: Colors.grey,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _isLoading // إذا كانت حالة التحميل مفعلة
                          ? CircularProgressIndicator() // عرض مؤشر التحميل
                          : CustomMaterialButton(
                              title: "حفظ",
                              vertical: hScreen * 0.01,
                              buttonColor: MyColors.kmainColor,
                              textColor: Colors.white,
                              borderWidth: 0.5,
                              borderColor: MyColors.kmainColor,
                              height: hScreen * 0.05,
                              width: wScreen * 0.25,
                              textsize: fSize * 0.9,
                              onPressed: () => _saveExpense(),
                            ),
                      _isLoading
                          ? SizedBox()
                          : CustomMaterialButton(
                              title: "طباعة",
                              vertical: hScreen * 0.01,
                              buttonColor: MyColors.kmainColor,
                              textColor: Colors.white,
                              borderWidth: 0.5,
                              borderColor: MyColors.kmainColor,
                              height: hScreen * 0.05,
                              width: wScreen * 0.25,
                              textsize: fSize * 0.9,
                              onPressed: () =>
                                  _saveExpense(printAfterSave: true),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
